//
//  NewPartnerSearchVC.swift
//  DevSocial
//
//  Created by Jake Correnti on 6/1/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

class NewPartnerSearchVC: UIViewController {
	
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
	
	lazy var scrollView: UIScrollView = {
		let view = UIScrollView()
		return view
	}()
	
	lazy var titleTF: CustomTextField = {
		let view = CustomTextField()
		view.configure(placeholder: "Title...")
		return view
	}()
	
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
		view.addSubview(scrollView)
    }
	
	private func constrainScrollView() {
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			
		])
	}
}
