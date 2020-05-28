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
    static let shared = FirebaseStorageContext()
    let db = Firestore.firestore()
    
    /// save the given user to Firestore
    func saveUser(user: User, onError: @escaping (Error?) -> Void) {
        db.collection("users").document(user.id).setData([
            "username"    : user.username,
            "email"       : user.email,
            "dateCreated" : user.dateCreated,
            "id"          : user.id,
            "fcmTokens"   : user.fcmTokens
        ]) { (error) in
            if let error = error {
                onError(error)
            }
        }
    }
	
	/// save the given user to Firebase
	func saveUser(user: User, onError: @escaping (Error?) -> Void, onSuccess: @escaping () -> Void) {
		db.collection("users").document(user.id).setData([
            "username"    : user.username,
            "email"       : user.email,
            "dateCreated" : user.dateCreated,
            "id"          : user.id,
            "fcmTokens"   : user.fcmTokens
        ]) { (error) in
            if let error = error {
                onError(error)
			} else {
				onSuccess()
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
    
    /// get list of all users excluding the one that is logged in
    func getListOfAllUsers(onSuccess: @escaping (_ users: [User]) -> Void) {
        db.collection("users").getDocuments { (snapshot, error) in
            if let error = error {
                Alert.showBasicAlert(on: MyMessagesVC(), with: error.localizedDescription)
            } else {
                var users = [User]()
                for document in snapshot!.documents where document.data()["id"] as? String != Auth.auth().currentUser?.uid {
                    users.append(User(
                        username	: document.data()["username"] as! String,
                        email		: document.data()["email"] as! String,
                        dateCreated : Timestamp(),
                        id		    : document.data()["id"] as! String,
                        fcmTokens   : document.data()["fcmTokens"] as! [String]
                    ))
                }
                onSuccess(users)
            }
        }
    }
    
    /// gets the list of all users within the app that the user also hasn't created a chat with previously
	func getListOfAllUnmessagedUsers(onSuccess: @escaping (_ users: [User], _ listener: ListenerRegistration) -> Void, onError: @escaping (_ error: Error?) -> Void) {
		var unmessagedUsers = [User]()
		getListOfAllUsers { (users) in
			MessagesManager.shared.getMessagedUsers(onSuccess: { (messagedUsers, listener) in
				users.forEach { user in
					if !messagedUsers.contains(where: { $0.id == user.id }) { unmessagedUsers.append(user) }
				}
				onSuccess(unmessagedUsers, listener)
			}) { (error) in
				if let error = error { onError(error) }
			}
		}
	}

  
    func checkUsernameExists(username: String, onError: @escaping (Error?) -> Void, nameExists: @escaping (Bool?) -> Void) {
        db.collection("usernames").document(username.lowercased()).getDocument { (document, error) in
            if let error = error {
                onError(error)
            }
            
            if let doc = document {
                nameExists(doc.exists)
            }
        }
    }
    
    func addUsername(username: String, uid: String, onError: @escaping (Error?) -> Void) {
        db.collection("usernames").document(username.lowercased()).setData([
            "id"          : uid
        ]) { (error) in
            if let error = error {
                onError(error)
            }
        }
    }
	
	func getAllFCMTokens(for user: User, onError: @escaping (Error?) -> Void, onSuccess: @escaping ([String]) -> Void) {
		db.collection("users").whereField("id", isEqualTo: user.id).getDocuments { (userQuery, error) in
			if let error = error {
				onError(error)
			} else {
				guard let userQuery = userQuery?.documents else { return }
				if userQuery.count == 1 {
					let user = User(dictionary: userQuery.first!.data())
					onSuccess(user!.fcmTokens)
				}
			}
		}
	}
}
