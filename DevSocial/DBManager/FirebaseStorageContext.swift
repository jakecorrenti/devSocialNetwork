//
//  FirebaseStorageContext.swift
//  DevSocial
//
//  Created by Jake Correnti on 3/29/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Firebase

class FirebaseStorageContext: StorageContext {
    
    let db = Firestore.firestore()
    
    /// save a user to Firestore
    func saveUser(user: User, onError: @escaping (Error?) -> Void) {
        db.collection("users").document(user.id).setData([
            "username"    : user.username,
            "email"       : user.email,
            "dateCreated" : user.dateCreated,
            "id"          : user.id
        ]) { (error) in
            if let error = error {
                onError(error)
            }
        }
    }
    
    /// delete a user's documents and collections from Firestore 
    func deleteUser(user: User, onError: @escaping (Error?) -> Void) {
        db.collection("users").document(user.id).delete { (error) in
            if let error = error {
                onError(error)
            }
        }
    }
    
    func checkUsernameExists(username: String, onError: @escaping (Error?) -> Void, nameExists: @escaping (Bool?) -> Void) {
        db.collection("usernames").document(username).getDocument { (document, error) in
            if let error = error {
                onError(error)
            }
            
            if let doc = document {
                nameExists(doc.exists)
            }
        }
    }
    
    func addUsername(username: String, uid: String, onError: @escaping (Error?) -> Void) {
        db.collection("usernames").document(username).setData([
            "id"          : uid
        ]) { (error) in
            if let error = error {
                onError(error)
            }
        }
    }
}
