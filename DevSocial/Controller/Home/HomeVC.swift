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

class HomeVC: UITableViewController {
    
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
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        let messages = UIBarButtonItem(image: UIImage(systemName: Images.messages), style: .plain, target: self, action: #selector(messagesButtonPressed))
        navigationItem.rightBarButtonItem = messages
        self.title = "Home"
    }
    
    private func setupUI() {
        tableView = UITableView(frame: self.tableView.frame, style: .grouped)
        tableView.register(HomeRequestCell.self, forCellReuseIdentifier: homeRequestCellID)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
    }
    
    @objc func signout() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    @objc func messagesButtonPressed() {
        navigationController?.pushViewController(MyMessagesVC(), animated: true)
    }
}

extension HomeVC {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: homeRequestCellID) as! HomeRequestCell
        
        cell.title = "This is our title"
        
        cell.profileImage = UIImage(named: Images.emptyProfileImage)
        cell.authorName = "Johnny Appleseed"
        cell.authorHeadline = "Software Engineer at Google"
        
        cell.dateInfo = "Posted 3 Days ago (March 25, 2020 at 4:00 PM)"
        
        cell.layoutSubviews()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
