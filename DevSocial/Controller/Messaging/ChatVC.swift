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
    
    var inputBottomAnchor : NSLayoutConstraint!
    var selectedUser      : User!
    var docReference	  : DocumentReference?
	var docID             : String?
	var chatCreationState : ChatCreationState!
	var threadListener    : ListenerRegistration?
	
	let currentUser 	  = Auth.auth().currentUser!
    var messages    	  = [[Message]]()
	
    var formater		  : DateFormatter {
        let f 		 = DateFormatter()
        f.dateFormat = "M/d/yyyy"
        return f
    }
    
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
    
	lazy var textInputView: InputView = {
		let view = InputView()
		view.textView.delegate 				   = self
		view.textView.isUserInteractionEnabled = true
		view.textView.text 					   = "Enter message..."
		view.textView.textColor 			   = UIColor(named: ColorNames.secondaryTextColor)
		return view
	}()
    
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
        
        self.navigationController?.navigationBar.barTintColor = UIColor(named: ColorNames.accessory)
        self.navigationController?.navigationBar.isTranslucent = false
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
			tableView.bottomAnchor.constraint(equalTo: textInputView.bgView.topAnchor)
        ])
    }
	
	private func loadChat() {
		showLoadingView()
		MessagesManager.shared.loadChat(with: selectedUser, onError: { [weak self] (error) in
			if let error = error {
				guard let self = self else { return }
				Alert.showBasicAlert(on: self, with: error.localizedDescription)
			}
		}) { [weak self] (messages, docReference, listener) in
			guard let self 		   = self else { return }
			self.messages          = messages
			self.docReference      = docReference
			self.threadListener    = listener
			self.tableView.reloadData()
			self.scrollChatToBottom()
			self.dismissLoadingView()
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
	
	private func sendNotificationToUser(for message: Message) {
		NotificationManager.shared.sendPushNotification(to: selectedUser, title: message.senderName, body: message.content)
	}

	private func handleSendButtonState() {
		let contents = textInputView.textView.text
		if contents == nil || contents == "" {
			textInputView.setSendButtonDeactivatedState()
		} else {
			let trimmedContents = contents?.trimmingCharacters(in: .whitespacesAndNewlines)
			if trimmedContents == nil || trimmedContents == "" {
				textInputView.setSendButtonDeactivatedState()
			} else {
				textInputView.setSendButtonActivatedState()
			}
		}
	}
	
	private func handleTextInputTextViewSize() {
		let size 		  = CGSize(width: view.frame.width - 74, height: .infinity)
		let estimatedSize = textInputView.textView.sizeThatFits(size)

		textInputView.textView.constraints.forEach { constraint in
			if constraint.firstAttribute == .height {
				if estimatedSize.height <= 35 {
					constraint.constant 				   = 35
					textInputView.textView.isScrollEnabled = false
				} else if Int(estimatedSize.height) >= 195 {
					constraint.constant 				   = 195
					textInputView.textView.isScrollEnabled = true
				} else {
					constraint.constant 				   = estimatedSize.height
					textInputView.textView.isScrollEnabled = false
				}
			}
		}
	}

	private func scrollChatToBottom() {
		if messages.count > 0 {
			tableView.scrollToRow(at: IndexPath(row: messages[messages.count - 1].count - 1, section: messages.count - 1), at: .top, animated: true)
		}
	}
    
    @objc
    private func sendButtonPressed() {
		let message = Message(
			id		   : UUID().uuidString,
			content    : textInputView.textView.text!,
			created    : Timestamp(),
			senderID   : currentUser.uid,
			senderName : currentUser.displayName!,
			wasRead    : false
		)
		
		if messages.count == 0 {
			createChat { [weak self] (docID) in
				self?.save(message: message, docID: docID) { [weak self] in
					self?.insertMessageLocally(message)
					self?.loadChat()
				}
			}
		} else {
			guard let docReference = docReference else { return }
			save(message: message, docRef: docReference) { [weak self] in
				self?.insertMessageLocally(message)
			}
		}
		
		sendNotificationToUser(for: message)
		for constraint in textInputView.textView.constraints where constraint.firstAttribute == .height {
			constraint.constant = 35
		}
		textInputView.textView.text = ""
		tableView.reloadData()
		textInputView.setSendButtonDeactivatedState()
		scrollChatToBottom()
    }
    
    @objc
    private func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue    = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame   = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            inputBottomAnchor.constant = .zero
            tableView.contentInset     = .zero
        } else {
            inputBottomAnchor.constant 		= -keyboardViewEndFrame.height + view.safeAreaInsets.bottom
            tableView.contentInset 	   		= UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom + inputBottomAnchor.constant, right: 0)
            tableView.scrollIndicatorInsets = tableView.contentInset

			UIView.animate(withDuration: 0, animations: { [weak self] () -> Void in
				guard let self = self else { return }
				self.view.layoutIfNeeded()
			}, completion: { [weak self] _ in
				guard let self = self else { return }
				self.scrollChatToBottom()
			})
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
			let lastMessage       = self.messages.count == 1 && self.messages[0].count == 1
			
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

    @objc
	func tap() {
        view.endEditing(true)
    }
}

extension ChatVC: UITextViewDelegate {
	func textViewDidChange(_ textView: UITextView) {
		handleSendButtonState()
		handleTextInputTextViewSize()
	}
	
	func textViewDidBeginEditing(_ textView: UITextView) {
		if textView.text == "Enter message..." {
			textView.text = ""
			textView.textColor = UIColor(named: ColorNames.primaryTextColor)
		}
	}
	
	func textViewDidEndEditing(_ textView: UITextView) {
		if textView.text == "" || textView.text == nil {
			textView.text      = "Enter message..."
			textView.textColor = UIColor(named: ColorNames.secondaryTextColor)
		}
	}
}
