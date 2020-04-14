//
//  NewMessageVC.swift
//  DevSocial
//
//  Created by Jake Correnti on 4/2/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit
import Firebase

class NewMessageVC: UITableViewController {
    
    // -----------------------------------------
    // MARK: Properties
    // -----------------------------------------
    var users = [User]()
    var filteredUsers = [User]()
    var isSeachBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        return searchController.isActive && !isSeachBarEmpty
    }
    
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
    
    lazy var searchController: UISearchController = {
        let view = UISearchController(searchResultsController: nil)
        view.searchResultsUpdater = self
        view.obscuresBackgroundDuringPresentation = false
        view.searchBar.placeholder = "Search users"
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
        getUsers()
    }
    
    private func getUsers() {
//        FirebaseStorageContext.shared.getListOfAllUsers { (users) in
//            self.users = users
//            self.tableView.reloadData()
//        }
        FirebaseStorageContext.shared.getListOfAllUnmessagedUsers { (users) in
            self.users = users
            self.tableView.reloadData()
        }
    }
    
    // -----------------------------------------
    // MARK: Setup UI
    // -----------------------------------------
    
    private func setupNavBar() {
        view.backgroundColor = UIColor(named: ColorNames.background)
        navigationItem.title = "New message"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        tableView.register(NewMessageCell.self, forCellReuseIdentifier: Cells.newMessageCell)
        tableView.tableFooterView = UIView()
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filteredUsers = users.filter { (user: User) -> Bool in
        return user.username.lowercased().contains(searchText.lowercased())
      }
      
      tableView.reloadData()
    }
}

extension NewMessageVC {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering {
            return filteredUsers.count
        }
        
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.newMessageCell, for: indexPath) as! NewMessageCell
        
        cell.backgroundColor = UIColor(named: ColorNames.background)
        if isFiltering {
            cell.selectedUser = filteredUsers[indexPath.row]
        } else {
            cell.selectedUser = users[indexPath.row]
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        MessagesManager.shared.createChat(with: users[indexPath.row].id) { (error) in
            if let error = error {
                Alert.showBasicAlert(on: self, with: error.localizedDescription)
            }
        }
        
        let user: User!
        
        if isFiltering {
            user = filteredUsers[indexPath.row]
        } else {
            user = users[indexPath.row]
        }
        
        let chat = ChatVC()
        chat.selectedUser = user
        navigationController?.pushViewController(chat, animated: true)
    }
}

extension NewMessageVC: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    // TODO
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
  }
}
