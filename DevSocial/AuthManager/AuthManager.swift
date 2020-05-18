//
//  AuthManager.swift
//  DevSocial
//
//  Created by Jake Correnti on 3/29/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import Foundation
import Firebase
import GoogleSignIn
import AuthenticationServices

final class AuthManager {
    static let shared = AuthManager()
    let auth = Auth.auth()
    
    /// sign a user into Firebase using their email and password
    func signInWithFirebase(email: String, password: String, onError: @escaping (_ error: Error?) -> Void) {
        auth.signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                onError(error)
            }
        }
    }

    func signInWithAppleUser(credential: AuthCredential, user: ASAuthorizationAppleIDCredential, onSuccess: @escaping () -> Void, onError: @escaping (Error?) -> Void) {
        let firstName = user.fullName?.givenName ?? ""
        let lastName  = user.fullName?.familyName ?? ""
        let email     = user.email ?? ""

        completeSignInWithCredentials(credential: credential, firstName: firstName, lastName: lastName, email: email, onSuccess: {
            onSuccess()
        }, onError: { error in
            onError(error)
        })
    }

    func signInWithGoogleUser(credential: AuthCredential, user: GIDGoogleUser, onSuccess: @escaping () -> Void, onError: @escaping (Error?) -> Void) {
        let firstName = user.profile.givenName ?? ""
        let lastName  = user.profile.familyName ?? ""
        let email     = user.profile.email ?? ""

        completeSignInWithCredentials(credential: credential, firstName: firstName, lastName: lastName, email: email, onSuccess: {
            onSuccess()
        }, onError: { error in
            onError(error)
        })
    }

	/// abstracted functionality to make signing in with google and apple is unified
    private func completeSignInWithCredentials(credential: AuthCredential, firstName: String, lastName: String, email: String, onSuccess: @escaping () -> Void, onError: @escaping (Error?) -> Void) {
        
		Auth.auth().signIn(with: credential) { (authResult, error) in
			if let error = error {
				onError(error)
			} else {
				AuthManager.shared.getFCMToken { (fcmToken) in
					let user = User(
						username    : "\(firstName)\(lastName)\(UUID().uuidString)",
						email       : email,
						dateCreated : Timestamp(),
						id          : Auth.auth().currentUser!.uid,
						fcmToken    : fcmToken,
						headline    : ""
					)
					
					Firestore.firestore().collection("users").document(Auth.auth().currentUser!.uid).getDocument { (snapshot, error) in
						if let error = error {
							onError(error)
						} else {
							if !snapshot!.exists {
								let profileChangeRequest = self.auth.currentUser!.createProfileChangeRequest()
								profileChangeRequest.displayName = user.username
								profileChangeRequest.commitChanges { (error) in
									if let error = error {
										onError(error)
									} else {
										FirebaseStorageContext.shared.saveUser(user: user, onError: { (error) in
											if let error = error {
												onError(error)
											}
										}) {
											// save the username
											FirebaseStorageContext.shared.addUsername(username: user.username, uid: user.id) { error in
												if let error = error {
													onError(error)
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
    }

    
    /// create a user in Firebase using a username, email, and password
    func createUserWithFirebase(username: String, email: String, password: String, onError: @escaping (_ error: Error?) -> Void) {
        auth.createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                onError(error)
            } else {
                let storageContext = FirebaseStorageContext.shared
                // if the user is created successfully, set up their username in Firebase
                let profileChangeRequest          = self.auth.currentUser?.createProfileChangeRequest()
                profileChangeRequest?.displayName = username
                profileChangeRequest?.commitChanges(completion: { [weak self] (commitError) in
					guard let self = self else { return }
                    if let commitError = commitError {
                        onError(commitError)
                    } else {

						self.getFCMToken { (fcmToken) in
							let user = User(
								username	: username.lowercased(),
								email		: email,
								dateCreated : Timestamp(),
								id			: self.auth.currentUser!.uid,
								fcmToken	: fcmToken,
								headline	: ""
							)
							
							storageContext.saveUser(user: user, onError: { (error) in
								if let error = error {
									onError(error)
								}
							}) {
								storageContext.addUsername(username: user.username, uid: user.id) { (error) in
									if let error = error {
										onError(error)
									}
								}
							}
						}
                    }
                })
            }
        }
    }
    
    func getFCMToken(onSuccess: @escaping (_ token: String) -> Void) {
        
        InstanceID.instanceID().instanceID { (result, error) in
          if let error = error {
            print("Error fetching remote instance ID: \(error)")
          } else if let result = result {
            print("Remote instance ID token: \(result.token)")
            onSuccess(result.token)
          }
        }
    }
}
