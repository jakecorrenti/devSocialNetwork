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
    // MARK: Properties
    // -----------------------------------------
	
	private var fabIsTapped = false
	
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
		let view = FloatingActionButton(imageName: Images.plus)
		view.layer.cornerRadius = 30
		view.addTarget(self, action: #selector(fabPressed), for: .touchUpInside)
		return view
	}()

	lazy var newSearchFAB: FloatingActionButton = {
		let view = FloatingActionButton(imageName: Images.magnifyingGlass, pointSize: 15)
		view.layer.cornerRadius = 30
		view.alpha = 0
		view.addTarget(self, action: #selector(newSearchFABPressed), for: .touchUpInside)
		return view
	}()

	lazy var newRequestFAB: FloatingActionButton = {
		let view = FloatingActionButton(imageName: Images.personPlus, pointSize: 15)
		view.layer.cornerRadius = 30
		view.alpha = 0
		view.addTarget(self, action: #selector(newRequestFABPressed), for: .touchUpInside)
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
		[tableView, fab, newSearchFAB, newRequestFAB].forEach { view.addSubview($0) }
		constrainTableView()
		constrainFAB()
		constrainNewSearchFAB()
		constrainNewRequestFAB()
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

	private func constrainNewSearchFAB() {
		newSearchFAB.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			newSearchFAB.heightAnchor.constraint(equalToConstant: 60),
			newSearchFAB.widthAnchor.constraint(equalToConstant: 60),
			newSearchFAB.centerYAnchor.constraint(equalTo: fab.centerYAnchor),
			newSearchFAB.centerXAnchor.constraint(equalTo: fab.centerXAnchor)
		])
	}

	private func constrainNewRequestFAB() {
		newRequestFAB.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			newRequestFAB.heightAnchor.constraint(equalToConstant: 60),
			newRequestFAB.widthAnchor.constraint(equalToConstant: 60),
			newRequestFAB.centerYAnchor.constraint(equalTo: fab.centerYAnchor),
			newRequestFAB.centerXAnchor.constraint(equalTo: fab.centerXAnchor)
		])
	}
	
	private func generateHapticFeedback() {
		let generator = UIImpactFeedbackGenerator(style: .medium)
		generator.impactOccurred()
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

	private func animateFabPressed() {
		UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [.curveEaseOut], animations: { [weak self] in
			guard let self = self else { return }
			self.fab.backgroundColor = .lightGray
			self.fab.transform = CGAffineTransform(rotationAngle: .pi * 0.75 )
			self.newSearchFAB.alpha = 1
			self.newSearchFAB.transform = CGAffineTransform(translationX: -35, y: -90)
			self.newRequestFAB.alpha = 1
			self.newRequestFAB.transform = CGAffineTransform(translationX: -90, y: -25)
		}) { _ in
			
		}
	}

	private func animateFabClosed(completion: @escaping () -> Void) {
		UIView.animate(withDuration: 0.25, animations: { [weak self] in
			guard let self = self else { return }
			self.fab.backgroundColor = UIColor(named: ColorNames.mainColor)
			self.fab.transform = CGAffineTransform(rotationAngle: 0)
			self.newSearchFAB.alpha = 0
			self.newSearchFAB.transform = CGAffineTransform(translationX: 0, y: 0)
			self.newRequestFAB.alpha = 0
			self.newRequestFAB.transform = CGAffineTransform(translationX: 0, y: 0)
		}, completion: { _ in
			completion()
		})

	}

	@objc
	private func fabPressed() {
		fabIsTapped = !fabIsTapped
		generateHapticFeedback()
		fab.pulsate()
		if fabIsTapped {
			animateFabPressed()
		} else {
			animateFabClosed { }
		}
	}
	
	@objc
	private func newSearchFABPressed() {
		fabIsTapped = !fabIsTapped
		generateHapticFeedback()
		newSearchFAB.pulsate()
		animateFabClosed { [weak self] in
			let postVC = NewPostVC()
			postVC.postType = .projectSearch
			postVC.isModalInPresentation = true
			self?.present(UINavigationController(rootViewController: postVC), animated: true, completion: nil)
		}
	}
	
	@objc
	private func newRequestFABPressed() {
		fabIsTapped = !fabIsTapped
		generateHapticFeedback()
		newRequestFAB.pulsate()
		animateFabClosed { [weak self] in
			let postVC = NewPostVC()
			postVC.isModalInPresentation = true
			postVC.postType = .partnerSearch
			self?.present(UINavigationController(rootViewController: postVC), animated: true, completion: nil)
		}
	}
    
    @objc
	func messagesButtonPressed() {
        navigationController?.pushViewController(MyMessagesVC(), animated: true)
    }
}
