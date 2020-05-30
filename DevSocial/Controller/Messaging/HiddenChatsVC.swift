//
//  HiddenChatsVC.swift
//  DevSocial
//
//  Created by Jake Correnti on 5/28/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit
import Firebase

class HiddenChatsVC: UIViewController {
	
    // -----------------------------------------
    // MARK: Properties
    // -----------------------------------------
	
	private var hiddenUsers = [User]()
	private var hiddenChatDocs = [DocumentSnapshot]()
	
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
	
	lazy var tableView: UITableView = {
		let view 		     = UITableView()
		view.backgroundColor = .systemBackground
		view.dataSource 	 = self
		view.delegate        = self
		view.separatorStyle  = .none
		view.tableFooterView = UIView()
		view.register(MessagedUserCell.self, forCellReuseIdentifier: Cells.messagedUserCell)
		return view
	}()
	
    // -----------------------------------------
    // MARK: Lifecycle
    // -----------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
		getHiddenChatsWithUsers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        setupUI()
    }
    
    // -----------------------------------------
    // MARK: Setup UI
    // -----------------------------------------
    
    private func setupNavBar() {
		view.backgroundColor = .systemBackground
		navigationItem.title = "Hidden chats"
		
		let doneCapsuleButton = CapsuleButton(type: .system)
		doneCapsuleButton.configure(title: "Done", color: UIColor(named: ColorNames.mainColor)!)
		let doneButton = UIBarButtonItem(customView: doneCapsuleButton)
		doneCapsuleButton.addTarget(self, action: #selector(doneButtonPressed), for: .touchUpInside)
		navigationItem.rightBarButtonItem = doneButton
    }
    
    private func setupUI() {
		view.addSubview(tableView)
		constrainTableView()
    }
	
	private func constrainTableView() {
		tableView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])
	}
	
	private func getHiddenChatsWithUsers() {
		showLoadingView()
		MessagesManager.shared.getHiddenChatsWithUsers(onSuccess: { [weak self] (users, documents) in
			guard let self = self else { return }
			self.hiddenUsers = users
			self.hiddenChatDocs = documents
			self.dismissLoadingView()
			self.tableView.reloadData()
		}) { [weak self] (error) in
			guard let self = self else { return }
			if let error = error {
				Alert.showBasicAlert(on: self, with: error.localizedDescription)
			}
		}
	}
	
	func getHiddenUsers() -> [User] {
		return hiddenUsers
	}
	
	func getHiddenChatDocuments() -> [DocumentSnapshot] {
		return hiddenChatDocs
	}
	
	@objc
	private func doneButtonPressed() {
		dismiss(animated: true, completion: nil)
	}
}
