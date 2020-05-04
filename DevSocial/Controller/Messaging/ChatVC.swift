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
    
    var inputBottomAnchor: NSLayoutConstraint!
    var selectedUser     : User!
    var docReference	 : DocumentReference?
	var docID            : String?
    let currentUser 	 = Auth.auth().currentUser!
    var messages    	 = [[Message]]()
	var chatCreationState: ChatCreationState!
	var threadListener   : ListenerRegistration?
	
    var formater		 : DateFormatter {
        let f 		 = DateFormatter()
        f.dateFormat = "M/d/yyyy"
        return f
    }
    
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
    
    lazy var textInputView = InputView()
    
    lazy var tableView: UITableView = {
        let view 				 = UITableView(frame: .zero, style: .grouped)
        view.dataSource 		 = self
        view.delegate 			 = self
        view.sectionHeaderHeight = 50
        view.tableFooterView     = UIView()
        view.keyboardDismissMode = .interactive
        view.estimatedRowHeight  = 100
        view.separatorStyle      = .none
        view.rowHeight 	         = UITableView.automaticDimension
        view.backgroundColor     = UIColor(named: ColorNames.background)
        view.register(MessageCell.self, forCellReuseIdentifier: Cells.messageCell)
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
		threadListener?.remove()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        setupUI()
        setupObservers()
		checkChatCreationState()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
        textInputView.sendButton.addTarget(self, action: #selector(sendButtonPressed), for: .touchUpInside)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
		threadListener?.remove()
    }
    
    // -----------------------------------------
    // MARK: Setup UI
    // -----------------------------------------
    
    private func setupNavBar() {
        view.backgroundColor = UIColor(named: ColorNames.background)
        navigationItem.title = selectedUser.username
    }
    
    private func setupUI() {
        [textInputView, tableView].forEach { view.addSubview($0) }
        
		tableView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleMessageLongPress(sender:))))
		
        constrainTextInputView()
        constrainTableView()
    }
	
	private func checkChatCreationState() {
		if chatCreationState == .existing {
			loadChat()
		}
	}
    
    private func setupObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    private func constrainTextInputView() {
        inputBottomAnchor = textInputView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        
        textInputView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            inputBottomAnchor,
            textInputView.widthAnchor.constraint(equalTo: view.widthAnchor),
            textInputView.heightAnchor.constraint(equalToConstant: 58)
        ])
    }
    
    private func constrainTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: textInputView.topAnchor)
        ])
    }
	
	private func loadChat() {
		MessagesManager.shared.loadChat(with: selectedUser, onError: { [weak self] (error) in
			if let error = error {
				guard let self = self else { return }
				Alert.showBasicAlert(on: self, with: error.localizedDescription)
			}
		}) { [weak self] (messages, docReference, listener) in
			guard let self 		= self else { return }
			self.messages       = messages
			self.docReference   = docReference
			self.threadListener = listener
			self.tableView.reloadData()
		}
	}

    private func createChat(handler: @escaping (_ docID: String) -> Void) {
		MessagesManager.shared.createChat(with: selectedUser.id, onError: { [weak self] error in
            if let error = error {
				guard let self = self else { return }
                Alert.showBasicAlert(on: self, with: error.localizedDescription)
            }
        }, onSuccess: { docID in
            handler(docID)
        })
    }

	private func save(message: Message, docID: String, handler: @escaping () -> Void) {
		MessagesManager.shared.save(message: message, at: docID, onError: { [weak self] (error) in
			if let error = error {
				guard let self = self else { return }
				Alert.showBasicAlert(on: self, with: error.localizedDescription)
			}
		}) {
			handler()
		}
    }
	
	private func save(message: Message, docRef: DocumentReference, handler: @escaping () -> Void) {
		MessagesManager.shared.save(message: message, at: docRef, onError: { [weak self] (error) in
			if let error = error {
				guard let self = self else { return }
				Alert.showBasicAlert(on: self, with: error.localizedDescription)
			}
		}) {
			handler()
		}
    }
	
	private func insertMessageLocally(_ message: Message) {
		if messages.count == 0 {
			messages.append([message])
		} else {
			var messageGroup = messages.last
			messageGroup?.append(message)
		}
		tableView.reloadData()
	}
    
    @objc
    private func sendButtonPressed() {
		let message = Message(
			id		   : UUID().uuidString,
			content    : textInputView.textField.text!,
			created    : Timestamp(),
			senderID   : currentUser.uid,
			senderName : currentUser.displayName!,
			wasRead    : false
		)

		if messages.count == 0 {
			createChat { [weak self] docID in
				guard let self = self else { return }
				self.save(message: message, docID: docID) { [weak savedSelf = self] in
					guard let savedSelf = savedSelf else { return }
					savedSelf.insertMessageLocally(message)
					savedSelf.loadChat()
				}
			}
		} else {
			guard let docReference = docReference else { return }
			save(message: message, docRef: docReference) { [weak self] in
				guard let self = self else { return }
				self.insertMessageLocally(message)
			}
		}
		
		//MARK: - Send Notifications
		// get FCM token from FirebaseStorage
		// use the notificationManager to send the message
		
		textInputView.textField.text = ""
		tableView.reloadData()
		textInputView.setSendButtonDeactivatedState()
        
    }
    
    @objc
    private func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            inputBottomAnchor.constant = .zero
            tableView.contentInset     = .zero
        } else {
            inputBottomAnchor.constant = -keyboardViewEndFrame.height + view.safeAreaInsets.bottom
            tableView.contentInset 	   = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom + inputBottomAnchor.constant, right: 0)
            
            tableView.scrollIndicatorInsets = tableView.contentInset
        }
        
    }
	
	@objc
	func handleMessageLongPress(sender: UILongPressGestureRecognizer) {
		if sender.state == .began {
			let longPressLocation = sender.location(in: tableView)
			let indexPathSelected = tableView.indexPathForRow(at: longPressLocation)
			
			guard let indexPath   = indexPathSelected else { return }
			let cell			  = tableView.cellForRow(at: indexPath) as! MessageCell
			let messageSender     = self.messages[indexPath.section][indexPath.row].senderID
			let lastMessage = self.messages.count == 1 && self.messages[0].count == 1
			
			if messageSender == self.currentUser.uid && !lastMessage {
				cell.bubbleView.backgroundColor = UIColor(named: ColorNames.secondaryTextColor)

				Alert.showDeleteConfirmation(on: self, onDeleteSelected: {
					guard let docReference = self.docReference else { return }
					let message			   = self.messages[indexPath.section][indexPath.row]
					
					MessagesManager.shared.deleteMessage(message: message, docReference: docReference, onSuccess: {
						// no action needs to be taken when the document is updated, the screen automatically updates since there is a snapshot listener on it
					}) { (error) in
						if let error = error {
							Alert.showBasicAlert(on: self, with: "Oh no!", message: error.localizedDescription)
						}
					}
					
				}) {
					sender.state = .ended
					cell.bubbleView.backgroundColor = UIColor(named: ColorNames.mainColor)
				}
			}
		}
	}

    @objc func tap() {
        view.endEditing(true)
    }
}
