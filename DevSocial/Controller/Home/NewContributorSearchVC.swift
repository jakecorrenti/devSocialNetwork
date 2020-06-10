//
//  NewContributorSearchVC.swift
//  DevSocial
//
//  Created by Jake Correnti on 6/10/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

class NewContributorSearchVC: UITableViewController {
	
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
    }
    
    // -----------------------------------------
    // MARK: Setup UI
    // -----------------------------------------
    
    private func setupNavBar() {
		view.backgroundColor = .systemBackground
		tableView.backgroundColor = .systemBackground
    }
    
    private func setupUI() {
        
    }
}
