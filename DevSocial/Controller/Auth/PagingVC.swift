//
//  PagingVC.swift
//  DevSocial
//
//  Created by Jake Correnti on 3/28/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit
import Parchment

class PagingVC: UIViewController {
    
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
    
    var pagingController = PagingViewController()
    
    // -----------------------------------------
    // MARK: Lifecycle
    // -----------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        setupPagingViews()
        setupUI()
    }
    
    // -----------------------------------------
    // MARK: Setup UI
    // -----------------------------------------
    
    private func setupNavBar() {
        view.backgroundColor = UIColor(named: ColorNames.background)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    private func setupPagingViews() {
        let login = LoginVC()
        let signup = SignupVC()
        
        login.title = "Login"
        signup.title = "Sign up"
        
        pagingController = PagingViewController(viewControllers: [login, signup])
        pagingController.textColor = .systemGray
        pagingController.backgroundColor = UIColor(named: ColorNames.background)!
        pagingController.selectedBackgroundColor = UIColor(named: ColorNames.background)!
        pagingController.selectedTextColor = UIColor(named: ColorNames.mainColor)!
        pagingController.indicatorOptions = .hidden
        pagingController.borderOptions = .hidden
        pagingController.menuItemSize = .fixed(width: 100, height: 25)
        pagingController.menuBackgroundColor = UIColor(named: ColorNames.background)!
    }
    
    private func setupUI() {
        addChild(pagingController)
        view.addSubview(pagingController.view)
        pagingController.didMove(toParent: self)
        pagingController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pagingController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pagingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pagingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pagingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
