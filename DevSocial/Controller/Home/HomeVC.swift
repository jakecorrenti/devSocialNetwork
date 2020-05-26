//
//  HomeVC.swift
//  DevSocial
//
//  Created by Jake Correnti on 3/29/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit
import Firebase

private let homeRequestCellID = "homeRequestCellID"
private let homeSearchCellID = "homeSearchCellID"

class HomeVC: UITableViewController {
    
    // -----------------------------------------
    // MARK: Properties
    // -----------------------------------------
    
    var posts = [Post]()
    let currentUser = Auth.auth().currentUser ?? nil
    
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
    
    lazy var addPostButton: UIButton = {
        let button = UIButton()
        button.setTitle("T", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor(named: ColorNames.mainColor)
        button.titleLabel!.font = UIFont(name: "Helvetica neue", size: 35)
        button.addTarget(self, action: #selector(addPostButtonPressed), for: .touchUpInside)
        return button
    }()
    
    // -----------------------------------------
    // MARK: Lifecycle
    // -----------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadData()
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

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        self.navigationController?.navigationBar.barTintColor = UIColor(named: ColorNames.accessory)
        self.navigationController?.navigationBar.isTranslucent = false
        
        extendedLayoutIncludesOpaqueBars = true
        
		let messagesButton 	 = BadgeButton(type: .system)
		messagesButton.image = UIImage(systemName: Images.messages)
		messagesButton.addTarget(self, action: #selector(messagesButtonPressed), for: .touchUpInside)
		navigationItem.rightBarButtonItem = UIBarButtonItem(customView: messagesButton)
        
        let newPost = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPostButtonPressed))
        navigationItem.leftBarButtonItem = newPost
    }
    
    private func setupUI() {
        tableView = UITableView(frame: self.tableView.frame, style: .grouped)
        tableView.register(HomeRequestCell.self, forCellReuseIdentifier: homeRequestCellID)
        tableView.register(HomeSearchCell.self, forCellReuseIdentifier: homeSearchCellID)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.sectionHeaderHeight = 10
        tableView.sectionFooterHeight = 5
        
        self.view.addSubview(addPostButton)
        
        let margins = self.view.layoutMarginsGuide
        addPostButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 0).isActive = true
        addPostButton.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -20).isActive = true
        addPostButton.heightAnchor.constraint(equalToConstant: 65).isActive = true
        addPostButton.widthAnchor.constraint(equalToConstant: 65).isActive = true
        addPostButton.layer.cornerRadius = 65/2
    }
    
    private func loadData() {
        let manager = FirebaseStorageContext()
        manager.getConnectionPosts { (posts) in
            self.posts = posts.sorted(by: { $0.datePosted.dateValue() > $1.datePosted.dateValue() })
            self.tableView.reloadData()
        }
    }
    
    @objc func messagesButtonPressed() {
        navigationController?.pushViewController(MyMessagesVC(), animated: true)
    }
    
    @objc func addPostButtonPressed() {
        let nav = UINavigationController(rootViewController: NewPostVC())
        
        nav.modalPresentationStyle = .fullScreen
        nav.modalTransitionStyle = .coverVertical
        
        self.present(nav, animated: true, completion: nil)
    }
}

extension HomeVC {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = posts[indexPath.section]
        let formatter = DateFormatter()
        
        switch item.type {
        case .search:
            let cell = tableView.dequeueReusableCell(withIdentifier: homeSearchCellID) as! HomeSearchCell
            
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            
            cell.post = item
                        
            return cell
        case .request:
            let cell = tableView.dequeueReusableCell(withIdentifier: homeRequestCellID) as! HomeRequestCell
            
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

            cell.post = item
            
            return cell
        case .empty:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
