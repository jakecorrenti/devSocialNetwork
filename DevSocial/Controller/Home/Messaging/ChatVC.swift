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

class ChatVC: UIViewController {
    
    // -----------------------------------------
    // MARK: Properties
    // -----------------------------------------
    
    var selectedUser: User!
    private var docReference: DocumentReference?
    let currentUser = Auth.auth().currentUser!
    var messages = [Message]()
    private var messagesManager = MessagesManager()
    
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
    
    lazy var textInputView = InputView()
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.dataSource = self
        view.tableFooterView = UIView()
        view.keyboardDismissMode = .onDrag
        view.backgroundColor = UIColor(named: ColorNames.background)
        view.register(UITableViewCell.self, forCellReuseIdentifier: Cells.defaultCell)
        return view
    }()
    
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
                
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
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
    }
    
    private func setupUI() {
        [textInputView, tableView].forEach { view.addSubview($0) }
        
        constrainTextInputView()
        constrainTableView()
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
    
    private func constrainTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: textInputView.separatorView.topAnchor)
        ])
    }
    
    func createChat() {
        messagesManager.createChat(with: selectedUser.id) { (error) in
            if let error = error {
                Alert.showBasicAlert(on: self, with: error.localizedDescription)
            } else {
                self.loadChat()
            }
        }
    }
    
    private func loadChat() {
        messagesManager.loadChat(with: selectedUser, onError: { (error) in
            if let error = error {
                Alert.showBasicAlert(on: self, with: error.localizedDescription)
            }
        }) { (messages, docReference) in
            self.messages = messages
            self.docReference = docReference
            self.tableView.reloadData()
            self.tableView.scrollToRow(at: IndexPath(row: messages.count - 1, section: 0), at: .bottom, animated: true)
        }
    }
    
    private func insertNewMessage(_ message: Message) {
        //add the message to the messages array and reload it
        messages.append(message)
        tableView.reloadData()
        DispatchQueue.main.async {
            self.tableView.scrollToRow(at: IndexPath(row: self.messages.count - 1, section: 0), at: .bottom, animated: true)
        }
    }
    
    private func save(_ message: Message) {
        messagesManager.save(message: message, at: docReference) { (error) in
            if let error = error {
                Alert.showBasicAlert(on: self, with: error.localizedDescription)
            }
        }
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
        tableView.reloadData()
        self.tableView.scrollToRow(at: IndexPath(row: self.messages.count - 1, section: 0), at: .bottom, animated: true)
    }
}

extension ChatVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.defaultCell, for: indexPath)
        cell.textLabel?.text = messages[indexPath.row].content
        return cell
    }
}

