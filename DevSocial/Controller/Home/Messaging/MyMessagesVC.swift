//
//  MyMessagesVC.swift
//  DevSocial
//
//  Created by Jake Correnti on 3/30/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

class MyMessagesVC: UIViewController {
    
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
    let dbManager = FirebaseStorageContext()
    let messagesManager = MessagesManager()
    var numberOfUsers = 0
    var users = [User]()
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = UIColor(named: ColorNames.background)
        view.delegate = self
        view.dataSource = self
        view.register(UITableViewCell.self, forCellReuseIdentifier: Cells.defaultCell)
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
        
        messagesManager.getListOfMessagedUsers { (users) in
            self.numberOfUsers = users.count
            self.users = users.sorted { $0.username < $1.username }
            self.tableView.reloadData()
        }
    }
    
    // -----------------------------------------
    // MARK: Setup UI
    // -----------------------------------------
    
    private func setupNavBar() {
        view.backgroundColor = UIColor(named: ColorNames.background)
        navigationItem.title = "Messages"
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        navigationItem.rightBarButtonItem = addButton
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc func addButtonPressed() {
        
    }
}

extension MyMessagesVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfUsers
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.defaultCell, for: indexPath)
        cell.textLabel?.text = users[indexPath.row].username
        return cell
    }
}

extension MyMessagesVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let chat = ChatVC(collectionViewLayout: UICollectionViewFlowLayout())
        let chat = ChatVC()
        chat.selectedUser = users[indexPath.row]
        navigationController?.pushViewController(chat, animated: true)
    }
}
