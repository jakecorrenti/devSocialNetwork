//
//  HomeVC.swift
//  DevSocial
//
//  Created by Jake Correnti on 3/29/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit
import Firebase

class HomeVC: UITableViewController {
    
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
    
//    lazy var tableview: UITableView = {
//        let tb = UITableView()
//        tb.delegate = self
//        tb.dataSource = self
//        return tb
//    }()
    
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
        let messages = UIBarButtonItem(image: UIImage(systemName: Images.messages), style: .plain, target: self, action: #selector(messagesButtonPressed))
        navigationItem.rightBarButtonItem = messages
        self.title = "Home"
    }
    
    private func setupUI() {
        // MARK: Removing sign up button
//        let button = UIButton()
//        button.setTitle("sign out", for: .normal)
//        button.setTitleColor(.red, for: .normal)
//        button.addTarget(self, action: #selector(signout), for: .touchUpInside)
//
//        view.addSubview(button)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive  = true
//        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    
//        constrainTableView()
    }
    
//    private func constrainTableView() {
//        tableview.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            tableview.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
//            tableview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
//            tableview.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
//            tableview.topAnchor.constraint(equalTo: view.topAnchor, constant: 0)
//        ])
//    }
    
    @objc func signout() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    @objc func messagesButtonPressed() {
        
    }
}

extension HomeVC {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
