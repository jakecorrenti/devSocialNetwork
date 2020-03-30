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
    }
    
    private func setupUI() {
        let button = UIButton()
        button.setTitle("sign out", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.addTarget(self, action: #selector(signout), for: .touchUpInside)
        
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive  = true
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    @objc func signout() {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
        
    }
}
