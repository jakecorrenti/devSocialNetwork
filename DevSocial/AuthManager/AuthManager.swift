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
                // if the user is created successfully, set up their username in Firebase
                let profileChangeRequest          = self.auth.currentUser?.createProfileChangeRequest()
                profileChangeRequest?.displayName = username
                profileChangeRequest?.commitChanges(completion: { (commitError) in
                    if let commitError = commitError {
                        onError(commitError)
                    } else {
                        // if all of the auth is valid, add the user to the databse
                        let user      = User(
                            username   : username,
                            email      : email,
                            dateCreated: Date(),
                            id         : self.auth.currentUser!.uid
                        )
                        
                        FirebaseStorageContext.shared.saveUser(user: user) { (error) in
                            if let error = error {
                                onError(error)
                            }
                        }
                        
                        FirebaseStorageContext.shared.addUsername(username: username, uid: user.id) { (error) in
                            if let error = error {
                                onError(error)
                            }
                        }
                    }
                })
            }
        }
    }
}
