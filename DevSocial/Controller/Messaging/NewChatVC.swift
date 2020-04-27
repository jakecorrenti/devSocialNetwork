//
//  NewChatVC.swift
//  DevSocial
//
//  Created by Jake Correnti on 4/25/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit
import Firebase

class NewChatVC: UIViewController {
	
    // -----------------------------------------
    // MARK: Properties
    // -----------------------------------------
	var selectedUsers 	   = [User]()
	var allUnmessagedUsers = [User]()
	var userSearchResults  = [User]()
	var isSearchBarEmtpy: Bool {
		return searchController.searchBar.text?.isEmpty ?? true
	}
	
	var isSearchingUsers: Bool {
		return searchController.isActive && !isSearchBarEmtpy
	}
	
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
	
	lazy var collectionView: UICollectionView = {
		let viewLayout = UICollectionViewFlowLayout()
		let view 	   = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
		viewLayout.scrollDirection = .horizontal
		view.backgroundColor 	   = .red
		view.dataSource 		   = self
		view.delegate 			   = self
		view.register(UICollectionViewCell.self, forCellWithReuseIdentifier: Cells.defaultCell)
		return view
	}()
	
	lazy var tableView: UITableView = {
		let view = UITableView()
		view.backgroundColor = .blue
		view.isHidden 		 = true
		view.dataSource 	 = self
		view.delegate	     = self
		view.register(UITableViewCell.self, forCellReuseIdentifier: Cells.defaultCell)
		return view
	}()
	
	lazy var searchController: UISearchController = {
		let view = UISearchController(searchResultsController: nil)
		view.searchResultsUpdater 				  = self
		view.obscuresBackgroundDuringPresentation = false
		view.searchBar.placeholder 				  = "Search users"
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
		getUnmessagedUsers()
    }
    
    // -----------------------------------------
    // MARK: Setup UI
    // -----------------------------------------
    
    private func setupNavBar() {
		view.backgroundColor 			 = UIColor(named: ColorNames.background)
		navigationItem.title 			 = "New chat"
		navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
		
		navigationItem.searchController  = searchController
		definesPresentationContext 	     = true
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
		FirebaseStorageContext.shared.getListOfAllUnmessagedUsers(onSuccess: { (users) in
			self.allUnmessagedUsers = users
		}) { (error) in
			if let error = error {
				Alert.showBasicAlert(on: self, with: "Oh no!", message: error.localizedDescription)
			}
		}
	}
	
	private func searchUnmessagedUsers(for username: String) {
		userSearchResults = allUnmessagedUsers.filter { (user: User) -> Bool in
			return user.username.lowercased().contains(username.lowercased())
		}
		tableView.reloadData()
	}
}

extension NewChatVC: UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		tableView.isHidden = !isSearchingUsers
		searchUnmessagedUsers(for: searchController.searchBar.text!)
	}
}

