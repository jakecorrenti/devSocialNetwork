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
                profileChangeRequest?.commitChanges(completion: { (commitError) in
                    if let commitError = commitError {
                        onError(commitError)
                    } else {
                        // if all of the auth is valid, add the user to the databse
                        var fcmToken: String = ""
                        
                        self.getFCMToken { (token) in
                            fcmToken = token
                        }
                        
                        let user      = User(
                            username   : username.lowercased(),
                            email      : email,

                            dateCreated: Timestamp(),
                            id         : self.auth.currentUser!.uid
                            fcmToken   : fcmToken
                        )
                        
                        storageContext.saveUser(user: user) { (error) in
                            if let error = error {
                                onError(error)
                            }
                        }
                        
                        storageContext.addUsername(username: username, uid: user.id) { (error) in
                            if let error = error {
                                onError(error)
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
