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
                        username: document.data()["username"] as! String,
                        email: document.data()["email"] as! String,
                        dateCreated: Timestamp(),
                        id: document.data()["id"] as! String,
                        fcmTokens: document.data()["fcmTokens"] as! [String],
                        headline: document.data()["headline"] as? String ?? "New User"
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
    
    func createPost(post: Post, onError: @escaping (_ error: Error?) -> Void, onSuccess: @escaping () -> Void) {
                
        db.collection("posts").document(post.uid).setData([
            "title"       : post.title,
            "type"        : post.type.rawValue,
            "desc"        : post.desc ?? "",
            "uid"         : post.uid,
            "user"        : ["username"     :post.profile.username,
                             "email"        :post.profile.email,
                             "headline"     :post.profile.headline,
                             "dateCreated"  :post.profile.dateCreated,
                             "id"           :post.profile.id
                            ],
            "datePosted"  : post.datePosted,
            "lastEdited"  : post.lastEdited ?? "",
            "keywords"    : post.keywords
        ]) { (error) in
            if let error = error {
                onError(error)
            }
        }
        
        onSuccess()
    }
    
    func getConnectionPosts(onSuccess: @escaping (_ posts: [Post]) -> Void) {
        db.collection("posts").getDocuments { (snapshot, error) in
            if let error = error {
                Alert.showBasicAlert(on: MyMessagesVC(), with: error.localizedDescription)
            } else {
                var posts = [Post]()
                for document in snapshot!.documents {
                    
                    let results = document.data()
                    
                    if let user = results["user"] as? [String: Any] {
                        posts.append(Post(
                        title         : results["title"] as! String,
                        type          : PostType(results["type"] as! String) ?? .empty,
                        desc          : results["desc"] as? String ?? "",
                        uid           : results["uid"] as! String,
                        profile: User (
										username        : user["username"] as? String ?? "",
										email           : user["email"] as? String ?? "",
										dateCreated     : user["dateCreated"] as! Timestamp,
										id              : user["id"] as? String ?? "",
										//MARK: - UPDATE POST MODELS TO NOT REQUIRE THIS
										fcmTokens       : user["fcmTokens"] as? [String] ?? [String](),
										headline        : user["headline"] as? String ?? "New User"
                                      ),
                        datePosted    : results["datePosted"] as! Timestamp,
                        lastEdited    : results["lastEdited"] as? Timestamp ?? nil,
                        keywords      : results["keywords"] as! [String]))
                    }
                }
                onSuccess(posts)
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
    
    func updateFCMToken(onError: @escaping (Error?) -> Void) {
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                onError(error)
            } else if let result = result {
                self.db.collection("users").getDocuments { (snapshot, error) in
                    if let error = error {
                        onError(error)
                    } else {
                        for document in snapshot!.documents {
                            if document.data()["id"] as? String == Auth.auth().currentUser?.uid {
                                document.reference.updateData([
                                    "fcmToken" : result.token
                                ]) { (error) in
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
    
    func getFCMToken(for user: User, onError: @escaping (Error?) -> Void, onSuccess: @escaping (String?) -> Void) {
        self.db.collection("users").getDocuments { (snapshot, error) in
            if let error = error {
                onError(error)
            } else {
                for document in snapshot!.documents {
                    if document.data()["id"] as? String == user.id {
                        onSuccess(document.data()["fcmToken"] as? String)
                    }
                }
            }
        }
    }
	
	func getAllFCMTokens(for user: User, onError: @escaping )
}
