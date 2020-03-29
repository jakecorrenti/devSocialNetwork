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
    let auth = Auth.auth()
    
    func signInWithFirebase(email: String, password: String, error: @escaping (_ error: Error?) -> Void) {
        
    }
    
    func createUserWithFirebase(username: String, email: String, password: String, onError: @escaping (_ error: Error?) -> Void) {
        auth.createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                onError(error)
            } else {
                let profileChangeRequest = self.auth.currentUser?.createProfileChangeRequest()
                profileChangeRequest?.displayName = username
                profileChangeRequest?.commitChanges(completion: { (commitError) in
                    if let commitError = commitError {
                        onError(commitError)
                    } else {
                        let dbManager = FirebaseStorageContext()
                        let user = User(
                            username: username,
                            email: email,
                            dateCreated: Date(),
                            id: self.auth.currentUser!.uid
                        )
                        
                        do {
                            try dbManager.saveUser(user: user)
                        } catch {
                            onError(error)
                        }
                    }
                })
            }
        }
    }
}
