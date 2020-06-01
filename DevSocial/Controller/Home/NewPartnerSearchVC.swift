//
//  NewPartnerSearchVC.swift
//  DevSocial
//
//  Created by Jake Correnti on 6/1/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

class NewPartnerSearchVC: UIViewController {
	
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
	
	lazy var tableView: UITableView = {
		let view = UITableView(frame: .zero, style: .insetGrouped)
		view.backgroundColor = .systemBackground
		view.dataSource = self
		view.estimatedRowHeight = 65
		view.rowHeight = UITableView.automaticDimension
		view.register(TextFieldCell.self, forCellReuseIdentifier: Cells.textFieldCell)
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
    }
    
    // -----------------------------------------
    // MARK: Setup UI
    // -----------------------------------------
    
    private func setupNavBar() {
		view.backgroundColor = .systemBackground
    }
    
    private func setupUI() {
		view.addSubview(tableView)
		constrainTableView()
    }
	
	private func constrainTableView() {
		tableView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: view.topAnchor),
			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])
	}
}
