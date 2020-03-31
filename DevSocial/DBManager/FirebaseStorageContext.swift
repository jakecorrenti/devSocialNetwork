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
    
    func getListOfAllUsers(onSuccess: @escaping (_ users: [User]) -> Void) {
        db.collection("users").getDocuments { (snapshot, error) in
            if let error = error {
                Alert.showBasicAlert(on: MyMessagesVC(), with: error.localizedDescription)
            } else {
                var users = [User]()
                for document in snapshot!.documents {
                    users.append(User(
                        username: document.data()["username"] as! String,
                        email: document.data()["email"] as! String,
                        dateCreated: Date(),
                        id: document.data()["id"] as! String
                    ))
                }
                onSuccess(users)
            }
        }
    }
}
