//
//  HomeVC.swift
//  DevSocial
//
//  Created by Jake Correnti on 3/29/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit
import Firebase

class HomeVC: UIViewController {
    
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------

	lazy var tableView: UITableView = {
		let view = UITableView()
		view.backgroundColor = .systemBackground
		return view
	}()
	
	lazy var messagesButton: BadgeButton = {
		let view   = BadgeButton(type: .system)
		view.image = UIImage(systemName: Images.messages)
		view.addTarget(self, action: #selector(messagesButtonPressed), for: .touchUpInside)
		return view
	}()
	
	lazy var fab: FloatingActionButton = {
		let view = FloatingActionButton()
		view.layer.cornerRadius = 30
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
		[tableView, fab].forEach { view.addSubview($0) }
		constrainTableView()
		constrainFAB()
    }

	private func constrainTableView() {
		tableView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: view.topAnchor),
			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
		])
	}

	private func constrainFAB() {
		fab.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			fab.heightAnchor.constraint(equalToConstant: 60),
			fab.widthAnchor.constraint(equalToConstant: 60),
			fab.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
			fab.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
		])
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
