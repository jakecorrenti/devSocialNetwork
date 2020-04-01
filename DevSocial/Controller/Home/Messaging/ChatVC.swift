//
//  ChatVC.swift
//  DevSocial
//
//  Created by Jake Correnti on 3/30/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase

class ChatVC: UICollectionViewController {
    
    // -----------------------------------------
    // MARK: Properties
    // -----------------------------------------
    
    var selectedUser: User!
    private var docReference: DocumentReference?
    let currentUser = Auth.auth().currentUser!
    var messages = [Message]()
    
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
    
    lazy var textInputView = InputView()
    
    // -----------------------------------------
    // MARK: Lifecycle
    // -----------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        setupUI()
        
        collectionView.keyboardDismissMode = .onDrag
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: Cells.defaultCell)
        textInputView.sendButton.addTarget(self, action: #selector(sendButtonPressed), for: .touchUpInside)
    }
    
    // -----------------------------------------
    // MARK: Setup UI
    // -----------------------------------------
    
    @objc func tap() {
        view.endEditing(true)
    }
    
    private func setupNavBar() {
        view.backgroundColor = UIColor(named: ColorNames.background)
        navigationItem.title = selectedUser.username
        collectionView.backgroundColor = UIColor(named: ColorNames.background)
    }
    
    private func setupUI() {
        [textInputView].forEach { view.addSubview($0) }
        
        constrainTextInputView()
        loadChat()
    }
    
    private func constrainTextInputView() {
        textInputView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textInputView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            textInputView.widthAnchor.constraint(equalTo: view.widthAnchor),
            textInputView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func createChat() {
        let users = [self.currentUser.uid, selectedUser.id]
        let data: [String: Any] = [
            "users":users
        ]
        let db = Firestore.firestore().collection("chats")
        db.addDocument(data: data) { (error) in
            if let error = error {
                Alert.showBasicAlert(on: self, with: error.localizedDescription)
                return
            } else {
                self.loadChat()
            }
        }
    }
    
    private func loadChat() {
        let db = Firestore.firestore().collection("chats").whereField("users", arrayContains: currentUser.uid)
        
        db.getDocuments { (snapshot, error) in
            if let error = error {
                Alert.showBasicAlert(on: self, with: error.localizedDescription)
            } else {
                guard let queryCount = snapshot?.documents.count else { return }
                
                if queryCount == 0 { self.createChat() } else if queryCount == 1 {
                    for doc in snapshot!.documents {
                        let chat = Chat(dictionary: doc.data())
                        
                        if (chat?.users.contains(self.selectedUser.id))! {
                            self.docReference = doc.reference
                            
                            doc.reference.collection("thread").order(by: "created", descending: false).addSnapshotListener(includeMetadataChanges: true) { (threadQuery, error) in
                                if let error = error {
                                    Alert.showBasicAlert(on: self, with: error.localizedDescription)
                                } else {
                                    self.messages.removeAll()
                                    for message in threadQuery!.documents {
                                        let msg = Message(dictionary: message.data())
                                        print(message.data())
                                        print("MESSAGE!!!: \(msg)")
                                        self.messages.append(msg!)
                                        
                                        print("Data: \(msg?.content ?? "NO MESSAGE FOUND")")
                                    }
                                    self.collectionView.reloadData()
//                                    self.collectionView.scrollToItem(at: IndexPath(row: self.messages.count, section: 0), at: .bottom, animated: true)
                                }
                            }
                        }
                    }
                }
                    
            }
        }
    }
    
    private func insertNewMessage(_ message: Message) {
        //add the message to the messages array and reload it
        messages.append(message)
        collectionView.reloadData()
        DispatchQueue.main.async {
//            self.collectionView.scrollToItem(at: IndexPath(row: self.messages.count, section: 0), at: .bottom, animated: true)
        }
    }
    private func save(_ message: Message) {
        //Preparing the data as per our firestore collection
        let data: [String: Any] = [
            "content": message.content,
            "created": message.created,
            "id": message.id,
            "senderID": message.senderID,
            "senderName": message.senderName
        ]
        //Writing it to the thread using the saved document reference we saved in load chat function
        docReference?.collection("thread").addDocument(data: data, completion: { (error) in
            if let error = error {
                print("Error Sending message: \(error)")
                return
            }
//            self.collectionView.scrollToItem(at: IndexPath(row: self.messages.count, section: 0), at: .bottom, animated: true)
        })
    }
    
    
    @objc
    private func sendButtonPressed() {
        //When use press send button this method is called.
        let message = Message(id: UUID().uuidString, content: textInputView.textField.text!, created: "\(Date())", senderID: currentUser.uid, senderName: currentUser.displayName!)
        //calling function to insert and save message
        insertNewMessage(message)
        save(message)
        //clearing input field
        textInputView.textField.text = ""
        collectionView.reloadData()
//        self.collectionView.scrollToItem(at: IndexPath(row: self.messages.count, section: 0), at: .bottom, animated: true)

    }
}

extension ChatVC {
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.defaultCell, for: indexPath)
        cell.backgroundColor = .red
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if messages.count == 0 {
            print("There are no messages")
            return 0
        } else {
            return messages.count
        }
    }
}
