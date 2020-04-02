//
//  MessagesManager.swift
//  DevSocial
//
//  Created by Jake Correnti on 4/1/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase

final class MessagesManager {
    private let dbManager   = FirebaseStorageContext()
    private let currentUser = Auth.auth().currentUser!
    private let db          = Firestore.firestore()
    
    /// get list of all the users that the current user started a conversation with in messages
    func getListOfMessagedUsers(onSuccess: @escaping (_ users: [User]) -> Void) {
        db.collection("chats").whereField("users", arrayContains: currentUser.uid).getDocuments { (chatQuery, error) in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
            } else {
                var messagedUsersIDS = [String]()
                var messagedUsers    = [User]()
                for document in chatQuery!.documents {
                    for user in document.data()["users"] as! [String] {
                        if user != self.currentUser.uid {
                            messagedUsersIDS.append(user)
                        }
                    }
                }
                
                self.dbManager.getListOfAllUsers { (users) in
                    for id in messagedUsersIDS {
                        for user in users {
                            if id == user.id {
                                messagedUsers.append(user)
                            }
                        }
                    }
                    onSuccess(messagedUsers)
                }
            }
        }
    }
    
    /// create a new chat in the database
    func createChat(with userID: String, onError: @escaping (_ error: Error?) -> Void) {
        let users = [currentUser.uid, userID]
        let data: [String : Any] = [ "users" : users ]
        db.collection("chats").addDocument(data: data) { (error) in
            if let error = error {
                onError(error)
            }
        }
    }
    
    /// save a message the user sends into the database
    func save(message msg: Message, at docReference: DocumentReference?, onError: @escaping (_ error: Error?) -> Void) {
        let data: [ String : Any ] = [
            "content"    : msg.content,
            "created"    : msg.created,
            "id"         : msg.id,
            "senderID"   : msg.senderID,
            "senderName" : msg.senderName
        ]
        
        docReference?.collection("thread").addDocument(data: data) { (error) in
            if let error = error {
                onError(error)
            }
        }
    }
    
    /// load the chat that has been logged between the current user and another user within the app
    func loadChat(with user: User, onError: @escaping (_ error: Error?) -> Void, onSuccess: @escaping (_ messages: [Message], _ docReference: DocumentReference?) -> Void) {
        // on success returna list of messages that were sent between the users
        var documentReference: DocumentReference?
        var messages = [Message]()
        
        db.collection("chats").whereField("users", arrayContains: currentUser.uid).getDocuments { (snapshot, error) in
            if let error = error {
                onError(error)
            } else {
                guard let queryCount = snapshot?.documents.count else { return }
                
                if queryCount == 0 {
                    self.createChat(with: user.id) { (error) in
                        if let error = error {
                            onError(error)
                        }
                    }
                } else if queryCount == 1 {
                    for doc in snapshot!.documents {
                        let chat = Chat(dictionary: doc.data())
                        
                        if (chat?.users.contains(user.id))! {
                            documentReference = doc.reference
                            
                            doc.reference.collection("thread").order(by: "created", descending: false).addSnapshotListener(includeMetadataChanges: true) { (threadQuery, error) in
                                if let error = error {
                                    onError(error)
                                } else {
                                    messages.removeAll()
                                    for message in threadQuery!.documents {
                                        let msg = Message(dictionary: message.data())
                                        messages.append(msg!)
                                    }
                                    
                                    onSuccess(messages, documentReference)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
}
