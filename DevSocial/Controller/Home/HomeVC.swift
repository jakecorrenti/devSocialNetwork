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
	
	lazy var messagesButton: BadgeButton = {
		let view   = BadgeButton(type: .system)
		view.image = UIImage(systemName: Images.messages)
		view.addTarget(self, action: #selector(messagesButtonPressed), for: .touchUpInside)
		return view
	}()
    
    // -----------------------------------------
    // MARK: Lifecycle
    // -----------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
		checkUnreadMessages()
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
		view.backgroundColor = .systemBackground
        self.title = "Home"

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
		navigationItem.rightBarButtonItem = UIBarButtonItem(customView: messagesButton)
        
    }
    
    private func setupUI() {

    }
	
	private func checkUnreadMessages() {
		MessagesManager.shared.areUnreadMessagesPending(onSuccess: { [weak self] (unreadStatus) in
			if unreadStatus {
				self?.messagesButton.badge.isHidden = false
			} else {
				self?.messagesButton.badge.isHidden = true
			}
		}) { [weak self] (error) in
			guard let self = self else { return }
			if let error = error {
				Alert.showBasicAlert(on: self, with: error.localizedDescription)
			}
		}
	}
    
    @objc func messagesButtonPressed() {
        navigationController?.pushViewController(MyMessagesVC(), animated: true)
    }
}
