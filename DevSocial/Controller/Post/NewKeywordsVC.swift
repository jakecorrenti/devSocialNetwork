//
//  NewKeywordsVC.swift
//  DevSocial
//
//  Created by Mikhail Lozovyy on 4/25/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

class NewKeywordsVC: UITableViewController {
    
    // -----------------------------------------
    // MARK: Properties
    // -----------------------------------------
    
    let keywordCellID = "keywordCellID"
    
    var selectedKeywords: [String] = []
    var topKeywords: [String] = []
    var filteredKeywords: [String] = []
    
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
        self.title = "Home"
        
        self.navigationController?.navigationBar.barTintColor = UIColor(named: ColorNames.accessory)
        self.navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    private func setupUI() {
        tableView = UITableView(frame: self.tableView.frame, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: keywordCellID)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.sectionHeaderHeight = 10
        tableView.sectionFooterHeight = 5
    }
}
