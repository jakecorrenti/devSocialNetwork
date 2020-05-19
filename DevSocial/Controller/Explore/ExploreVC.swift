//
//  ExploreVC.swift
//  DevSocial
//
//  Created by Mikhail Lozovyy on 3/30/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

class ExploreVC : UIViewController {
    
    // -----------------------------------------
    // MARK: Properties
    // -----------------------------------------
    
    var explorePosts = [Post]()
    var allUsers = [User]()
    var searchedUsers = [User]()

    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isSearchingUsers: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
    
    lazy var searchController: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search Users"
        search.searchBar.barTintColor = UIColor(named: ColorNames.accessory)
        return search
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: ColorNames.background)
        view.delegate = self
        view.dataSource = self
        view.register(HomeSearchCell.self, forCellReuseIdentifier: Cells.postSearchCell)
        view.register(HomeRequestCell.self, forCellReuseIdentifier: Cells.postRequestCell)
        view.register(UserCell.self, forCellReuseIdentifier: Cells.userCell)
        view.estimatedRowHeight = 45
        view.rowHeight = UITableView.automaticDimension
        view.sectionHeaderHeight = 10
        view.sectionHeaderHeight = 5
        return view
    }()
    
    // -----------------------------------------
    // MARK: Lifecycle
    // -----------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        setupUI()
        getAllUsers()
    }
    
    // -----------------------------------------
    // MARK: Setup UI
    // -----------------------------------------
    
    private func setupNavBar() {
        view.backgroundColor = UIColor(named: ColorNames.background)
        
        self.navigationController?.navigationBar.barTintColor = UIColor(named: ColorNames.accessory)
        self.navigationController?.navigationBar.isTranslucent = false
        
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        
        constrainTableView()
    }
    
    private func constrainTableView() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func getAllUsers() {
        FirebaseStorageContext.shared.getListOfAllUsers { (users) in
            self.allUsers = users
        }
    }
    
    private func searchUsers(for username: String) {
        searchedUsers.removeAll()
        searchedUsers = allUsers.filter { (user: User) -> Bool in
            return user.username.lowercased().contains(username.lowercased())
        }
        tableView.reloadData()
    }
}

extension ExploreVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchUsers(for: searchController.searchBar.text!)
    }
}

extension ExploreVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if isSearchingUsers {
            return 1
        }
        
        return explorePosts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearchingUsers {
            return searchedUsers.count
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isSearchingUsers {
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.userCell) as! UserCell
            
            let user = searchedUsers[indexPath.row]
            cell.user = user
            
            return cell
        }
        
        let item = explorePosts[indexPath.section]
        
        switch item.type {
        case .search:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.postSearchCell) as! HomeSearchCell
            
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            
            cell.post = item
                        
            return cell
        case .request:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.postRequestCell) as! HomeRequestCell
            
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

            cell.post = item
            
            return cell
        case .empty:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
}
