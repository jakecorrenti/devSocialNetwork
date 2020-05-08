//
//  NewPostVC.swift
//  DevSocial
//
//  Created by Mikhail Lozovyy on 4/13/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit
import Firebase

class NewPostVC : UIViewController {
    
    // -----------------------------------------
    // MARK: Properties
    // -----------------------------------------
    
    let nameCellID = "nameCellID"
    let keywordCellID = "keywordCellID"
    let descCellID = "descCellID"
    
    let currentUser = Auth.auth().currentUser ?? nil
        
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
    
    lazy var segmentedView: CustomSegmentedControl = {
        let v = CustomSegmentedControl()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    lazy var tableView: UITableView = {
        let tb = UITableView(frame: .zero, style: .grouped)
        tb.delegate = self
        tb.dataSource = self
        tb.register(TextFieldCell.self, forCellReuseIdentifier: nameCellID)
        tb.register(UITableViewCell.self, forCellReuseIdentifier: keywordCellID)
        tb.register(TextViewCell.self, forCellReuseIdentifier: descCellID)
        tb.backgroundColor = UIColor(named: ColorNames.background)
        tb.rowHeight = UITableView.automaticDimension
        tb.estimatedRowHeight = 55
        tb.sectionHeaderHeight = 10
        tb.sectionFooterHeight = 5
        tb.translatesAutoresizingMaskIntoConstraints = false
        return tb
    }()
    
    // -----------------------------------------
    // MARK: Lifecycle
    // -----------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage =  nil
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
        self.title = "New Post"
                
        self.navigationController?.navigationBar.barTintColor = UIColor(named: ColorNames.accessory)
        self.navigationController?.navigationBar.isTranslucent = false
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonPressed))
        navigationItem.leftBarButtonItem = cancelButton
        
        let shareButton = UIBarButtonItem(title: "Share", style: .done, target: self, action: #selector(shareButtonPressed))
        navigationItem.rightBarButtonItem = shareButton
        navigationItem.rightBarButtonItem?.isEnabled = false
        navigationItem.rightBarButtonItem?.tintColor = UIColor(named: ColorNames.secondaryTextColor)
    }
    
    // TODO: update later
    private func setupUI() {
        [segmentedView, tableView].forEach { view.addSubview($0) }
                
        segmentedView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        segmentedView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        segmentedView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        segmentedView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        tableView.topAnchor.constraint(equalTo: segmentedView.bottomAnchor, constant: 0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
    }
    
    @objc func editingChanged(_ sender: UITextField) {
        guard let text = sender.text, !text.isEmpty else {
            navigationItem.rightBarButtonItem?.isEnabled = false
            navigationItem.rightBarButtonItem?.tintColor = UIColor(named: ColorNames.secondaryTextColor)
            return
        }
        
        navigationItem.rightBarButtonItem?.isEnabled = true
        navigationItem.rightBarButtonItem?.tintColor = UIColor(named: ColorNames.mainColor)
    }
    
    @objc func cancelButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func shareButtonPressed() {
        
        // TODO: Create more security, add keywords, change up UI
        var type = ""
        var title = ""
        var keywords: [String] = []
        var desc = ""
        
        if segmentedView.segmentedControl.selectedSegmentIndex == 0 {
            type = "search"
        } else {
            type = "request"
        }
        
        if let titleCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TextFieldCell, let titleText = titleCell.textField.text {
            title = titleText
        }
        
        if let descCell = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? TextViewCell, let descText = descCell.textView.text {
            desc = descText
        }
        
        AuthManager.shared.getFCMToken { (token) in
            let manager = FirebaseStorageContext()
            if let user = self.currentUser {
                let user = User(username: user.displayName!, email: user.email!, dateCreated: Timestamp(), id: user.uid, fcmToken: token, headline: "")
                let newPost = Post(title: title, type: PostType(type) ?? .empty, desc: desc, uid: UUID().uuidString, profile: user, datePosted: Timestamp(), lastEdited: Timestamp(), keywords: keywords)
                
                manager.createPost(post: newPost, onError: { (error) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }) {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        
    }
}
