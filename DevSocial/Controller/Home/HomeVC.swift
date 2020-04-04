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
        
        posts.append(Post(name: "Requesting work", type: .request))
        posts.append(Post(name: "Have PHP work", type: .search))
        posts.append(Post(name: "Requesting iOS work", type: .request))
        posts.append(Post(name: "Requesting Dev work", type: .request))
        posts.append(Post(name: "Have iOS work", type: .search))

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
        tableView.register(HomeSearchCell.self, forCellReuseIdentifier: homeSearchCellID)
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
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = posts[indexPath.row]
        
        switch item.type {
        case .search:
            let cell = tableView.dequeueReusableCell(withIdentifier: homeSearchCellID) as! HomeSearchCell
            
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            
            cell.title = item.name
            
            cell.desc = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea"
            
            cell.profileImage = UIImage(named: Images.emptyProfileImage)
            cell.authorName = "Johnny Appleseed"
            cell.authorHeadline = "Software Engineer at Google"
            
            cell.dateInfo = "Posted 3 Days ago (March 25, 2020 at 4:00 PM)"
            
            cell.layoutSubviews()
            
            return cell
        case .request:
            let cell = tableView.dequeueReusableCell(withIdentifier: homeRequestCellID) as! HomeRequestCell
            
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

            cell.title = item.name
            
            cell.profileImage = UIImage(named: Images.emptyProfileImage)
            cell.authorName = "Johnny Appleseed"
            cell.authorHeadline = "Software Engineer at Google"
            
            cell.dateInfo = "Posted 3 Days ago (March 25, 2020 at 4:00 PM)"
            
            cell.layoutSubviews()
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
