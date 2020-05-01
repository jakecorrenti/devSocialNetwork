//
//  MyMessagesVC.swift
//  DevSocial
//
//  Created by Jake Correnti on 3/30/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

class MyMessagesVC: UITableViewController {
    
    // -----------------------------------------
    // MARK: Properties
    // -----------------------------------------
    var users = [User]()
    var filteredUsers = [User]()
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
    
    lazy var searchController: UISearchController = {
        let view = UISearchController(searchResultsController: nil)
        view.searchResultsUpdater = self
        view.obscuresBackgroundDuringPresentation = false
        view.searchBar.placeholder = "Search messages"
        return view
    }()
    
    // -----------------------------------------
    // MARK: Lifecycle
    // -----------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
        getUsers()
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
        view.backgroundColor = UIColor(named: ColorNames.background)
        navigationItem.title = "Messages"
        
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        navigationItem.rightBarButtonItem = addButton
    }
    
    private func setupUI() {
        tableView.backgroundColor = UIColor(named: ColorNames.background)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(MessagedUserCell.self, forCellReuseIdentifier: Cells.messagedUserCell)
    }
    
    private func getUsers() {
		MessagesManager.shared.getListOfMessagedUsers { (users) in
			MessagesManager.shared.compareUserActivity(users: users) { (sortedUsers) in
				self.users = sortedUsers
				self.tableView.reloadData()
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
                DispatchQueue.main.async {
                    self.users.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                    self.tableView.reloadData()
                }
            }, onError: { error in
                if let error = error {
                    Alert.showBasicAlert(on: self, with: "An error occurred", message: error.localizedDescription)
                }
            })
        }
    }

    
    @objc func addButtonPressed() {
        navigationController?.pushViewController(NewChatVC(), animated: true)
    }
}

extension MyMessagesVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering {
            return filteredUsers.count
        }
        
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.messagedUserCell, for: indexPath) as! MessagedUserCell
		
		let user = isFiltering ? filteredUsers[indexPath.row] : users[indexPath.row]
		cell.selectedUser = user

        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = UIColor(named: ColorNames.background)
        return cell
    }
}

extension MyMessagesVC {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chat 			   = ChatVC()
        chat.selectedUser      = users[indexPath.row]
		chat.chatCreationState = .existing
        navigationController?.pushViewController(chat, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
}

extension MyMessagesVC: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    // TODO
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
  }

    public override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    public override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if isFiltering {
                deleteChat(with: filteredUsers[indexPath.row], at: indexPath)
            } else {
                deleteChat(with: users[indexPath.row], at: indexPath)
            }
        }
    }
}
