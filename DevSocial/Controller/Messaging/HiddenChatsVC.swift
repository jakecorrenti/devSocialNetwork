//
//  HiddenChatsVC.swift
//  DevSocial
//
//  Created by Jake Correnti on 5/28/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

class HiddenChatsVC: UIViewController {
	
    // -----------------------------------------
    // MARK: Properties
    // -----------------------------------------
	
	private var hiddenUsers = [User]()
	
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
		
		let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed))
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
		MessagesManager.shared.getHiddenChatsWithUsers(onSuccess: { [weak self] (users) in
			guard let self = self else { return }
			self.hiddenUsers = users
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
	
	@objc
	private func doneButtonPressed() {
		dismiss(animated: true, completion: nil)
	}
}
