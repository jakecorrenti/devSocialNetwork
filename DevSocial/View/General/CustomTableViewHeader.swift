//
//  CustomTableViewHeader.swift
//  DevSocial
//
//  Created by Jake Correnti on 6/2/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

class CustomTableViewHeader: UIView {
	
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
	
	lazy var titleLabel: UILabel = {
		let view = UILabel()
		view.font = .boldSystemFont(ofSize: 18)
		return view
	}()
    
	lazy var actionButton: UIButton = {
		let view = UIButton(type: .system)
		view.isHidden = true
		view.setTitleColor(.systemGray, for: .normal)
		return view
	}()
	
    // -----------------------------------------
    // MARK: Initialization
    // -----------------------------------------
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    // -----------------------------------------
    // MARK: Setup UI
    // -----------------------------------------
    
    private func setupUI() {
		[titleLabel, actionButton].forEach { addSubview($0) }
		
		constrainTitleLabel()
		constrainActionButton()
    }
	
	func configure(title: String, buttonTitle: String? = nil) {
		if buttonTitle != nil {
			actionButton.isHidden = false
			actionButton.setTitle(buttonTitle!, for: .normal)
			actionButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
		}
		titleLabel.text = title
	}
	
	private func constrainTitleLabel() {
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
			titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8)
		])
	}
	
	private func constrainActionButton() {
		actionButton.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			actionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
			actionButton.centerYAnchor.constraint(equalTo: centerYAnchor)
		])
	}

}
