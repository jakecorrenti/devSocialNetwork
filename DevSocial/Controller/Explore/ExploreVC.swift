//
//  ExploreVC.swift
//  DevSocial
//
//  Created by Mikhail Lozovyy on 3/30/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

class ExploreVC : UIViewController {
    
    // -----------------------------------------
    // MARK: Properties
    // -----------------------------------------
    
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
    
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
    }
    
    private func setupUI() {
       
    }
}
