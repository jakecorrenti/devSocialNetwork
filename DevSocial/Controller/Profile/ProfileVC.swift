//
//  ProfileVC.swift
//  DevSocial
//
//  Created by Mikhail Lozovyy on 3/30/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit
import Firebase

class ProfileVC : UIViewController {
    
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
		view.backgroundColor = .systemBackground
        
        let signOut = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(signout))
        navigationItem.rightBarButtonItem = signOut
    }
    
    // TODO: update later
    private func setupUI() {
    }
    
    @objc func signout() {
		AuthManager.shared.removeFCMToken(onSuccess: {
			let firebaseAuth = Auth.auth()
			do {
				try firebaseAuth.signOut()
			} catch let signOutError as NSError {
				print ("Error signing out: %@", signOutError)
			}
		}) { [weak self] (error) in
			guard let self = self else { return }
			if let error = error  {
				Alert.showBasicAlert(on: self, with: error.localizedDescription)
			}
		}
    }
}
