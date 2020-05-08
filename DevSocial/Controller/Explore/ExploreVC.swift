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
        search.searchBar.placeholder = "Search Notes"
        search.searchBar.barTintColor = UIColor(named: ColorNames.accessory)
        search.hidesNavigationBarDuringPresentation = false
        return search
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: ColorNames.background)
        view.isHidden = true
//        view.dataSource = self
//        view.delegate = self
        view.register(NewMessageCell.self, forCellReuseIdentifier: Cells.defaultCell)
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
    
    // TODO: update later
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
}

extension ExploreVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        tableView.isHidden = !isSearchingUsers
        
    }
}
