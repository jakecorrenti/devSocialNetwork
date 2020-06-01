//
//  NewPostVC.swift
//  DevSocial
//
//  Created by Jake Correnti on 5/31/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

class NewPostVC: UIViewController {
	
    // -----------------------------------------
    // MARK: Properties
    // -----------------------------------------
	
	var postType: PostType?
	let newPartnerSearchVC = NewPartnerSearchVC()
	
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
		guard postType != nil else { return }
		if postType! == .partnerSearch {
			constrainPartnerSearchVC()
		} else {
			
		}
    }
	
	private func constrainPartnerSearchVC() {
		add(viewController: newPartnerSearchVC)
		let partnerVC = newPartnerSearchVC.view!
		partnerVC.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			partnerVC.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			partnerVC.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			partnerVC.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			partnerVC.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])
	}
}
