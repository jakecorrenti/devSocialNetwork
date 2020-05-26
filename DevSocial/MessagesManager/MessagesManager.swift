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
	
    static let shared 		= MessagesManager()
    private let db          = Firestore.firestore()
    
    /// create a new chat in the database
    func createChat(with userID: String, onError: @escaping (_ error: Error?) -> Void) {
        let users = [Auth.auth().currentUser!.uid, userID]
        let data: [String : Any] = [
            "users"  : users, 
            "hidden" : [String]()
        ]
        db.collection("chats").addDocument(data: data) { (error) in
            if let error = error {
                onError(error)
            }
        }
    }

	/// create a new chat in the database
    func createChat(with userID: String, onError: @escaping (_ error: Error?) -> Void, onSuccess: @escaping (_ documentID: String) -> Void) {
        let users = [
            Auth.auth().currentUser!.uid,
            userID
        ]
        let data: [String : Any] = [
            "users"  : users,
            "hidden" : [String]()
        ]

        let docID = UUID().uuidString
        db.collection("chats").document(docID).setData(data) { error in 
            if let error = error { onError(error) } else {
                onSuccess(docID)
            }
        }
    }
    
    /// save a message the user sends into the database
	func save(message msg: Message, at docReference: DocumentReference?, onError: @escaping (_ error: Error?) -> Void, onSuccess: @escaping () -> Void) {
        let data: [ String : Any ] = [
            "content"    : msg.content,
            "created"    : msg.created,
            "id"         : msg.id,
            "senderID"   : msg.senderID,
            "senderName" : msg.senderName,
            "wasRead"    : msg.wasRead
        ]

        docReference?.collection("thread").addDocument(data: data) { (error) in
            if let error = error {
                onError(error)
			} else {
				onSuccess()
			}
        }
    }

	/// this method is used when the message sent is the very first message sent between the two users
    func save(message msg: Message, at docID: String, onError: @escaping (_ error: Error?) -> Void, onSuccess: @escaping () -> Void) {
        let data: [ String : Any ] = [
            "content"    : msg.content,
            "created"    : msg.created,
            "id"         : msg.id,
			
            "senderID"   : msg.senderID,
            "senderName" : msg.senderName,
            "wasRead"    : msg.wasRead
        ]

		db.collection("chats").document(docID).collection("thread").addDocument(data: data) { (error) in
            if let error = error {
                onError(error)
            } else {
                onSuccess()
            }
        }
    }
    
    /// load the chat that has been logged between the current user and another user within the app
	func loadChat(with user : User,
				  onError   : @escaping (_ error: Error?) -> Void,
				  onSuccess : @escaping (_ messages: [[Message]], _ docReference: DocumentReference?, _ docListener: ListenerRegistration) -> Void) {

		var documentReference : DocumentReference?
		var messages		  = [Message]()
		var listener		  : ListenerRegistration!
		
		db.collection("chats").whereField("users", arrayContains: Auth.auth().currentUser!.uid).getDocuments { (chatQuery, error) in
			if let error = error {
				onError(error)
			} else {
				guard let chatCount = chatQuery?.count else { return }
				
				if chatCount == 0 {
					
				} else {
					for userChat in chatQuery!.documents {
						let chat = Chat(dictionary: userChat.data())
						
						if (chat?.users.contains(user.id))! {
							documentReference = userChat.reference
							
							listener = userChat.reference.collection("thread").order(by: "created", descending: false).addSnapshotListener { [weak self] (threadQuery, error) in
								guard let self = self else { return }
								if let error = error {
									onError(error)
								} else {
									messages.removeAll()
									threadQuery!.documents.forEach { message in
										messages.append(Message(dictionary: message.data())!)
									}
									
									self.getMessagesSeparatedByDate(messages: messages) { (separatedMessages) in
										onSuccess(separatedMessages, documentReference, listener)
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
        var formatter: DateFormatter {
            let f = DateFormatter()
            f.dateFormat = "M/d/yyyy"
            return f
        }
        var dates = [String]()
        var groupedMessages = [[Message]]()
        
        for message in messages {
            if !dates.contains(formatter.string(from: message.created.dateValue())) {
                dates.append(formatter.string(from: message.created.dateValue()))
            }
        }
        
        // loop through the dates an compare it to the messages' create dates. then create a multi-dimensional array of messages sorted by their dates created
        for date in dates {
            var grouped = [Message]()
            for message in messages {
                if formatter.string(from: message.created.dateValue()) == date {
                    grouped.append(message)
                }
            }
            groupedMessages.append(grouped)
        }
        onSucces(groupedMessages)
    }
    
    /// gets the last sent message in the chat between the two users
    func getLastSentChat(with user: User, onSuccess: @escaping (_ lastMessage: Message?) -> Void) {
        db.collection("chats").whereField("users", arrayContains: Auth.auth().currentUser!.uid).getDocuments { (chatQuery, error) in
            if let error = error {
                print(" ❌ There was an error: \(error.localizedDescription)")
            } else {
                guard let chat = chatQuery?.documents else { return }

                if chat.count > 0 {
                    for document in chat {
                        let userChat = Chat(dictionary: document.data())
                        if (userChat?.users.contains(user.id))! {
                            let docReference = document.reference

                            docReference.collection("thread").order(by: "created", descending: false).getDocuments { (threadQuery, error) in
                                if let error = error {
                                    print("❌ An Error Occurred: \(error.localizedDescription)")
                                } else {
                                    var messages = [Message]()
                                    for message in threadQuery!.documents {
                                        let msg = Message(dictionary: message.data())
                                        messages.append(msg!)
                                    }

                                    self.getMessagesSeparatedByDate(messages: messages) { (messages) in
                                        onSuccess(messages.last?.last)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    
    /// compares the two users and their recent activity, and returns the proper boolean in order to sort properly
    func compareUserActivity(users: [User], onSuccess: @escaping (_ sortedUsers: [User]) -> Void) {
        var messages = [User : Message]()
        
		if users.count == 0 { onSuccess([User]()) }
		
        for user in users {
            getLastSentChat(with: user) { (message) in
                if let message = message {
                    messages[user] = message
                }
                if messages.count == users.count {
                    // sorts the dictionary, and returns an array of the sorted Users (to turn into sorted values, change map to $0.1) (to change to a sorted array of Tuples, change the map to just $0)
                    let sortedUsers = messages.sorted { $0.value.created.dateValue() > $1.value.created.dateValue() } .map { $0.0 }
                    onSuccess(sortedUsers)
                }
            }
        }
    }
    
    /// updates the wasRead state of the current message
    func updateWasReadState(message: Message, docReference: DocumentReference, osSuccess: @escaping (_ error: Error?) -> Void, onError: @escaping (_ error: Error?) -> Void) {
        
        docReference.collection("thread").whereField("id", isEqualTo: message.id).getDocuments { (messageQuery, error) in
            if let error = error {
                onError(error)
            } else {
                if messageQuery!.documents.count == 1 {
                    let document = messageQuery!.documents[0].reference
                    
                    document.updateData(["wasRead" : true]) { (error) in
                        if let error = error {
                            onError(error)
                        }
                    }
                }
            }
        }
    }

    /// this function decides how to handle the deletion of a chat based on database values
    func handleDeleteChatAction(user: User, onSuccess: @escaping () -> Void, onError: @escaping (_ error: Error?) -> Void) {
        db.collection(_: "chats").whereField("users", arrayContains: Auth.auth().currentUser!.uid).getDocuments { (chatQuery, error) in 
            if let error = error {
                onError(error)
            } else {
                guard let chats = chatQuery?.documents else { return }

                for document in chats {
                    let userChat = Chat(dictionary: document.data())
                    if (userChat?.users.contains(user.id))! {

                        var hiddenUsers = userChat!.hidden
                        hiddenUsers.append(Auth.auth().currentUser!.uid)

                        if hiddenUsers.count <= 2 {
                            // update the hidden status for the current user
                            self.updateHiddenStatus(for: hiddenUsers, at: document, onSuccess: {
                                onSuccess()
                            }, onError: { error in
                                if let error = error { onError(error) }
                            })
                        }
                    }
                }
            }
        }
    }

    /// this function updates the 'hidden' status of the current user in the database
    func updateHiddenStatus(for hiddenUsers: [String], at document: DocumentSnapshot, onSuccess: @escaping () -> Void, onError: @escaping (_ error: Error?) -> Void ) {
        document.reference.updateData([
            "hidden" : hiddenUsers
        ], completion: { error in
            if let error = error {
                onError(error)
            } else {
                onSuccess()
            }
        })
    }

    /// this function completely deletes the data representing the chat between the current user and the selected user in Firebase Firestore
	func deleteThread(at document: DocumentReference, onSuccess: @escaping () -> Void, onError: @escaping (_ error: Error?) -> Void) {
        document.collection("thread").getDocuments { (threadQuery, error) in
            if let error = error {
                onError(error)
            } else {
                for document in threadQuery!.documents {
                    document.reference.delete() { error in
                        if let error = error { onError(error) }
                    }
                }

                document.delete() { error in
                    if let error = error { onError(error) }
                }
                onSuccess()
            }
        }
    }

    /// determines the hidden state of the current user for the chat with the selected user
	func determineCurrentHiddenStatus(with user: User, onSuccess: @escaping (_ isHidden: Bool,_ document: DocumentSnapshot?) -> Void, onError: @escaping (_ error: Error?) -> Void ) {
		db.collection("chats").whereField("users", arrayContains: Auth.auth().currentUser!.uid).getDocuments { (chatQuery, error) in
			if let error = error {
				onError(error)
			} else {
				guard let chats = chatQuery?.documents else { return }
				
				var escaped = false
				for document in chats {
					let chat = Chat(dictionary: document.data())
					
					if (chat?.hidden.contains(Auth.auth().currentUser!.uid))! && (chat?.users.contains(user.id))! {
						escaped = true
						onSuccess(true, document)
					}
				}
				// this is still returning even when success is triggered
				if !escaped {
					onSuccess(false, nil)
				}
			}
		}
    }

	/// unhides the current chat with the user selected or creates a new one if a chat hasn't already been created
	func unhideChat(with user: User, at document: DocumentSnapshot?, onSuccess: @escaping () -> Void, onError: @escaping (_ error: Error?) -> Void ) {
		if document == nil {
			// checks to see if a chat already exists with the current user, else, create a new one
			var escaped = false
			self.createChat(with: user.id) { (error) in
				if let error = error {
					escaped = true
					onError(error)
				}
			}
			if !escaped {
				onSuccess()
			}
        } else {
			guard let document 	   = document else { return }
			let chat 			   = Chat(dictionary: document.data()!)
			var currentHiddenUsers = chat?.hidden

			currentHiddenUsers?.removeAll(where: { (username) -> Bool in
				return username == Auth.auth().currentUser!.uid
			})

			updateHiddenStatus(for: currentHiddenUsers!, at: document, onSuccess: {
				onSuccess()
			}) { (error) in
				if let error = error { onError(error) }
			}
		}
	}
	
	/// deletes a specifed message from the DB and updates the user's interface in real time, assuming the message is not the last message in the chat
	func deleteMessage(message: Message, docReference: DocumentReference, onSuccess: @escaping () -> Void, onError: @escaping (_ error: Error?) -> Void ) {
		docReference.collection("thread").getDocuments { (threadQuery, error) in
			if let error = error {
				onError(error)
			} else {
				guard let thread = threadQuery?.documents else { return }
				for document in thread {
					let msg = Message(dictionary: document.data())
					if message.id == msg?.id {
						document.reference.delete { (error) in
							if let error = error { onError(error) } else {
								onSuccess()
							}
						}
						break
					}
				}
			}
		}
	}
	
	/// get list of all the users that the current user started a conversation with in messages
	func getMessagedUsers(onSuccess: @escaping (_ users: [User],_ listener: ListenerRegistration) -> Void, onError: @escaping (_ error: Error?) -> Void) {
		var listener : ListenerRegistration!

		listener = db.collection("chats").whereField("users", arrayContains: Auth.auth().currentUser!.uid).addSnapshotListener({ [weak self] (chatQuery, error) in
			guard let self = self else { return }
			if let error = error {
				onError(error)
			} else {
				guard let chats = chatQuery?.documents else { return }
				
				if chats.count == 0 {
					onSuccess([User](), listener)
				}
				
				var messagedUsersIDs = [String]()
				chats.forEach { document in
					let chat 	    = Chat(dictionary: document.data())
					let hiddenUsers = chat!.hidden
					
					for user in chat!.users where user != Auth.auth().currentUser!.uid {
						if hiddenUsers.count == 2 {
							self.deleteThread(at: document.reference, onSuccess: { }) { (error) in
								if let error = error { onError(error) }
							}
						} else {
							if !hiddenUsers.contains(Auth.auth().currentUser!.uid) {
								messagedUsersIDs.append(user)
							}
						}
					}
					
					FirebaseStorageContext.shared.getListOfAllUsers { (users) in
						var messagedUsers = [User]()
						for user in users where messagedUsersIDs.contains(user.id) {
                            messagedUsers.append(user)
                        }
						onSuccess(messagedUsers, listener)
					}
				}
			}
		})
	}

    func getNumberOfUnreadMessages(onSuccess: @escaping (Int) -> Void, onError: @escaping (Error?) -> Void) {

    }

}
