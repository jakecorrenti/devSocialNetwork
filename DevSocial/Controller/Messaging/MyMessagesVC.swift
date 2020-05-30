//
//  MyMessagesVC.swift
//  DevSocial
//
//  Created by Jake Correnti on 3/30/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit
import Firebase

class MyMessagesVC: UIViewController {
    
    // -----------------------------------------
    // MARK: Properties
    // -----------------------------------------

    var users 			    = [User]()
    var filteredUsers       = [User]()
	var fabIsClicked        = false
	var chatsListener      : ListenerRegistration?
    var isSearchBarEmpty   : Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
	
	lazy var tableView: UITableView = {
		let view = UITableView()
		view.backgroundColor = .systemBackground
        view.delegate 		  = self
        view.dataSource 	  = self
		view.separatorStyle  = .none
        view.tableFooterView = UIView()
		view.refreshControl  = refresh
        view.register(MessagedUserCell.self, forCellReuseIdentifier: Cells.messagedUserCell)
		return view
	}()
    
    lazy var searchController: UISearchController = {
        let view = UISearchController(searchResultsController: nil)
        view.searchResultsUpdater 				  = self
        view.obscuresBackgroundDuringPresentation = false
        view.searchBar.placeholder 				  = "Search messages"
        return view
    }()
	
	lazy var fab: MyMessagesFAB = {
		let view = MyMessagesFAB()
		view.layer.cornerRadius = 30
		view.addTarget(self, action: #selector(fabPressed), for: .touchUpInside)
		return view
	}()
	
	lazy var newChatCapsuleButton: CapsuleButton = {
		let view = CapsuleButton(type: .system)
		view.configure(title: "New chat", color: .systemGreen)
		view.alpha = 0
		return view
	}()
	
	lazy var deletedMessagesCapsuleButton: CapsuleButton = {
		let view = CapsuleButton(type: .system)
		view.configure(title: "Deleted chats", color: .systemRed)
		view.alpha = 0
		return view
	}()
	
	var refresh = UIRefreshControl()
	
    // -----------------------------------------
    // MARK: Lifecycle
    // -----------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
		showLoadingView()
        getUsers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.isHidden = false
		chatsListener?.remove()
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
        navigationItem.title = "Messages"
        
        navigationItem.searchController  = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        extendedLayoutIncludesOpaqueBars = true
        definesPresentationContext 	     = true
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
		let hiddenButton = UIBarButtonItem(image: UIImage(systemName: Images.trashcan), style: .plain, target: self, action: #selector(showHiddenChatsVC))
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        navigationItem.rightBarButtonItems = [hiddenButton, addButton]
    }
    
    private func setupUI() {
		
		refresh.addTarget(self, action: #selector(refreshControlActivated(_:)), for: .valueChanged)
		[tableView, fab, deletedMessagesCapsuleButton, newChatCapsuleButton].forEach { view.addSubview($0) }
		constrainTableView()
		constrainFab()
		constrainDeleteMessageCapsuleButton()
		constrainNewChatCapsuleButton()
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
	
	private func constrainFab() {
		fab.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			fab.heightAnchor.constraint(equalToConstant: 60),
			fab.widthAnchor.constraint(equalToConstant: 60),
			fab.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
			fab.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
		])
	}
	
	private func constrainDeleteMessageCapsuleButton() {
		deletedMessagesCapsuleButton.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			deletedMessagesCapsuleButton.trailingAnchor.constraint(equalTo: fab.trailingAnchor),
			deletedMessagesCapsuleButton.centerYAnchor.constraint(equalTo: fab.centerYAnchor)
		])
	}
	
	private func constrainNewChatCapsuleButton() {
		newChatCapsuleButton.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			newChatCapsuleButton.trailingAnchor.constraint(equalTo: fab.trailingAnchor),
			newChatCapsuleButton.centerYAnchor.constraint(equalTo: fab.centerYAnchor)
		])
	}

    private func getUsers() {
		MessagesManager.shared.getMessagedUsers(onSuccess: { (users, listener) in
			MessagesManager.shared.compareUserActivity(users: users) { [weak self] (sortedUsers) in
				guard let self 	       = self else { return }
				if let currentListener = self.chatsListener { currentListener.remove() }
				self.users 		       = sortedUsers
				self.chatsListener     = listener
				self.tableView.reloadData()
				self.refresh.endRefreshing()
				self.dismissLoadingView()
			}
		}) { [weak self] (error) in
			guard let self = self else { return }
			if let error = error {
				Alert.showBasicAlert(on: self, with: error.localizedDescription)
			}
		}
    }

    private func filterContentForSearchText(_ searchText: String) {
        filteredUsers = users.filter { (user: User) -> Bool in
        return user.username.lowercased().contains(searchText.lowercased())
      }
      
      tableView.reloadData()
    }

    private func deleteChat(with user: User, at indexPath: IndexPath) {
        Alert.showDeleteConfirmation(on: self) {
            MessagesManager.shared.handleDeleteChatAction(user: user, onSuccess: {
                DispatchQueue.main.async { [ weak self] in
                    self?.users.remove(at: indexPath.row)
					self?.tableView.deleteRows(at: [indexPath], with: .fade)
                    self?.tableView.reloadData()
                }
            }, onError: { [weak self] error in
                if let error = error {
                    guard let self = self else { return }
                    Alert.showBasicAlert(on: self, with: "An error occurred", message: error.localizedDescription)
                }
            })
        }
    }
	
	private func fabSelected() {
		UIView.animate(withDuration: 0.25) {
			self.fab.transform = CGAffineTransform(rotationAngle: .pi * 0.75 )
			self.deletedMessagesCapsuleButton.alpha = 1
			self.deletedMessagesCapsuleButton.transform = CGAffineTransform(translationX: 0, y: -75)
			self.newChatCapsuleButton.alpha = 1
			self.newChatCapsuleButton.transform = CGAffineTransform(translationX: 0, y: -125)
		}
	}
	
	private func fabDeselected() {
		UIView.animate(withDuration: 0.25) {
			self.fab.transform = CGAffineTransform(rotationAngle: 0)
			self.deletedMessagesCapsuleButton.alpha = 0
			self.deletedMessagesCapsuleButton.transform = CGAffineTransform(translationX: 0, y: 0)
			self.newChatCapsuleButton.alpha = 0
			self.newChatCapsuleButton.transform = CGAffineTransform(translationX: 0, y: 0)
		}
	}

	
	@objc
	private func fabPressed() {
		fabIsClicked = !fabIsClicked
		if fabIsClicked {
			fabSelected()
		} else {
			fabDeselected()
		}
	}
    
    @objc
	func addButtonPressed() {
        navigationController?.pushViewController(NewChatVC(), animated: true)
    }
	
	@objc
	func refreshControlActivated(_ sender: UIRefreshControl) {
		getUsers()
	}
	
	@objc
	func showHiddenChatsVC() {
		present(UINavigationController(rootViewController: HiddenChatsVC()), animated: true, completion: nil)
	}
}

extension MyMessagesVC: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering {
            return filteredUsers.count
        }
		
		if users.count == 0 {
			tableView.setEmtpyState(image: UIImage(named: Images.myMessagesEmptyState), text: "You currently have no messages. \n Press \'+' to create a chat.")
		} else {
			tableView.restoreState()
		}
        
        return users.count
    }
    
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell		     = tableView.dequeueReusableCell(withIdentifier: Cells.messagedUserCell, for: indexPath) as! MessagedUserCell
		let user 		     = isFiltering ? filteredUsers[indexPath.row] : users[indexPath.row]
		cell.selectedUser    = user
        cell.backgroundColor = .systemBackground
        return cell
    }
}

extension MyMessagesVC: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chat 			   = ChatVC()
        chat.selectedUser      = users[indexPath.row]
		chat.chatCreationState = .existing
        navigationController?.pushViewController(chat, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
	
	public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if isFiltering {
                deleteChat(with: filteredUsers[indexPath.row], at: indexPath)
            } else {
                deleteChat(with: users[indexPath.row], at: indexPath)
            }
        }
    }
}

extension MyMessagesVC: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
  }
}
