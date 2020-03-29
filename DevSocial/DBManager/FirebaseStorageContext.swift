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
    
    func saveUser(user: User) throws {
        db.collection("users").document(user.id).setData([
            "username" : user.username,
            "email" : user.email,
            "dateCreated" : user.dateCreated,
            "id" : user.id
        ]) { (error) in
            if let error = error {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    func deleteUser(user: User) throws {
        // implement
    }
}
