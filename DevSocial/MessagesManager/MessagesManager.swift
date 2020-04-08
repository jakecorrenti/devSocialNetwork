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
    static let shared = MessagesManager()
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
                
                FirebaseStorageContext.shared.getListOfAllUsers { (users) in
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
    func loadChat(with user: User, onError: @escaping (_ error: Error?) -> Void, onSuccess: @escaping (_ messages: [[Message]], _ docReference: DocumentReference?) -> Void) {
        // on success returna list of messages that were sent between the users
        var documentReference: DocumentReference?
        var messages = [Message]()
        
        db.collection("chats").whereField("users", arrayContains: currentUser.uid).getDocuments { (snapshot, error) in
            if let error = error {
                print("❌ An error has occurred: \(error.localizedDescription)")
            } else {
                guard let queryCount = snapshot?.documents.count else { return }
                
                if queryCount == 0 {
                    //MARK: - chat was already created when the user wants to create a new message with another user. is this causing probelems?????
                    self.createChat(with: user.id) { (error) in
                        if let error = error {
                            onError(error)
                        }
                    }
                } else if queryCount >= 1 {
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
                                    
                                    self.getMessagesSeparatedByDate(messages: messages) { (messages) in
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

    /// creates the proper array format for the messages to be separated by date
    func getMessagesSeparatedByDate(messages: [Message], onSucces: @escaping (_ messages: [[Message]]) -> Void ) {
        var formater: DateFormatter {
            let f = DateFormatter()
            f.dateFormat = "M/d/yyyy"
            return f
        }
        var dates = [String]()
        var groupedMessages = [[Message]]()
        
        for message in messages {
            if !dates.contains(formater.string(from: message.created.dateValue())) {
                dates.append(formater.string(from: message.created.dateValue()))
            }
        }
        
        // loop through the dates an compare it to the messages' create dates. then create a multi-dimensional array of messages sorted by their dates created
        for date in dates {
            var grouped = [Message]()
            for message in messages {
                if formater.string(from: message.created.dateValue()) == date {
                    grouped.append(message)
                }
            }
            groupedMessages.append(grouped)
        }
        onSucces(groupedMessages)
    }
    
    /// gets the last sent message in the chat between the two users
    func getLastSentChat(with user: User, onSuccess: @escaping (_ lastMessage: Message?) -> Void ) {
        self.loadChat(with: user, onError: { (error) in
            if let error = error {
                print("There was an error: \(error.localizedDescription)")
            }
        }) { (messages, docReference) in
            onSuccess(messages.last?.last)
        }
    }
}
