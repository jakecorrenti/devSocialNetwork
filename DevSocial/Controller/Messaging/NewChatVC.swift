//
//  NewChatVC.swift
//  DevSocial
//
//  Created by Jake Correnti on 4/25/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit
import Firebase

protocol RemovedUserDelegate: class {
	func userRemovedFromCollectionView(user: User)
}

class NewChatVC: UIViewController {
	
    // -----------------------------------------
    // MARK: Properties
    // -----------------------------------------
	var selectedUsers 	   = [User]()
	var allUnmessagedUsers = [User]()
	var userSearchResults  = [User]()
	var userListener	   : ListenerRegistration?
	var isSearchBarEmpty: Bool {
		return searchController.searchBar.text?.isEmpty ?? true
	}
	
	var isSearchingUsers: Bool {
		return searchController.isActive && !isSearchBarEmpty
	}
	
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
	
	lazy var collectionView: UICollectionView = {
		let viewLayout 			   = UICollectionViewFlowLayout()
		let view 	   			   = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
		viewLayout.scrollDirection = .horizontal
		viewLayout.minimumInteritemSpacing = 0
		viewLayout.minimumLineSpacing      = 0
		view.backgroundColor 	   = UIColor(named: ColorNames.background)
		view.dataSource 		   = self
		view.delegate 			   = self
		view.register(NewChatUserCell.self, forCellWithReuseIdentifier: Cells.defaultCell)
		return view
	}()
	
	lazy var tableView: UITableView = {
		let view 			 = UITableView()
		view.backgroundColor = UIColor(named: ColorNames.background)
		view.isHidden 		 = true
		view.dataSource 	 = self
		view.delegate	     = self
		view.tableFooterView = UIView()
		view.register(NewMessageCell.self, forCellReuseIdentifier: Cells.defaultCell)
		return view
	}()
	
	lazy var searchController: UISearchController = {
		let view 								  = UISearchController(searchResultsController: nil)
		view.searchResultsUpdater 				  = self
		view.obscuresBackgroundDuringPresentation = false
		view.searchBar.placeholder 				  = "Search users"
		return view
	}()

	var nextButton = UIBarButtonItem()
	
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
		userListener?.remove()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        setupUI()
		getUnmessagedUsers()
    }
    
    // -----------------------------------------
    // MARK: Setup UI
    // -----------------------------------------
    
    private func setupNavBar() {
		view.backgroundColor 			  = UIColor(named: ColorNames.background)
		navigationItem.title 			  = "New chat"
		navigationItem.backBarButtonItem  = UIBarButtonItem(
												title : "",
												style : .plain,
												target: self,
												action: nil
											)

		nextButton						  = UIBarButtonItem(
												title : "Next",
												style : .done,
												target: self,
												action: #selector(nextButtonPressed)
											)
        
        navigationItem.searchController   = searchController
        definesPresentationContext           = true
        
        self.navigationController?.navigationBar.barTintColor = UIColor(named: ColorNames.accessory)
        self.navigationController?.navigationBar.isTranslucent = false
        extendedLayoutIncludesOpaqueBars = true
		
		nextButton.isEnabled			  = false
		navigationItem.rightBarButtonItem = nextButton
    }
    
    private func setupUI() {
		[collectionView, tableView].forEach { view.addSubview($0) }
		
		constrainCollectionView()
		constrainTableView()
    }
	
	private func constrainCollectionView() {
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			collectionView.heightAnchor.constraint(equalToConstant: 150)
		])
	}
	
	private func constrainTableView() {
		tableView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])
	}
	
	private func getUnmessagedUsers() {
		FirebaseStorageContext.shared.getListOfAllUnmessagedUsers(onSuccess: { [weak self] (users, listener) in
			guard let self 		    = self else { return }
			self.allUnmessagedUsers = users
			self.userListener 	    = listener
		}) { [weak self] (error) in
			guard let self = self else { return }
			if let error = error {
				Alert.showBasicAlert(on: self, with: error.localizedDescription)
			}
		}
	}
	
	private func searchUnmessagedUsers(for username: String) {
		userSearchResults = allUnmessagedUsers.filter { (user: User) -> Bool in
			return user.username.lowercased().contains(username.lowercased())
		}
		tableView.reloadData()
	}

	private func checkPreviousChatHistory(hasPreviousChat: @escaping (_ hasPrevious: Bool) -> Void) {
		guard let selectedUser = selectedUsers.first else { return }
		
		MessagesManager.shared.determineCurrentHiddenStatus(with: selectedUser, onSuccess: { (hiddenStatus, document) in
			if hiddenStatus {
				MessagesManager.shared.unhideChat(with: selectedUser, at: document, onSuccess: {
					hasPreviousChat(hiddenStatus)
				}) { [weak self] (error) in
					guard let self = self else { return }
					if let error = error {
						Alert.showBasicAlert(on: self, with: error.localizedDescription)
					}
				}
			} else {
				hasPreviousChat(hiddenStatus)
			}
		}) { [weak self] (error) in
			guard let self = self else { return }
			if let error = error {
				Alert.showBasicAlert(on: self, with: error.localizedDescription)
			}
		}
	}

	@objc
	private func nextButtonPressed() {
		checkPreviousChatHistory { [weak self] hasPreviousChat in
			guard let self 		   = self else { return }
			let chat 			   = ChatVC()
			chat.selectedUser 	   = self.selectedUsers.first
			chat.chatCreationState = hasPreviousChat ? .existing : .new
			self.navigationController?.pushViewController(chat, animated: true)
		}
	}

}

extension NewChatVC: UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		tableView.isHidden = !isSearchingUsers
		searchUnmessagedUsers(for: searchController.searchBar.text!)
	}
}

extension NewChatVC: RemovedUserDelegate {
	func userRemovedFromCollectionView(user: User) {
		// the loop should only happen once where there should only be one user with the same id as the selected user
		for (index, selectedUser) in selectedUsers.enumerated() where selectedUser.id == user.id {
			selectedUsers.remove(at: index)
			collectionView.deleteItems(at: [IndexPath(row: index, section: 0)])

			if selectedUsers.count == 0 { nextButton.isEnabled = false }
		}
	}
}

