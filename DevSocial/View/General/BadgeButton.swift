//
//  BadgeButton.swift
//  DevSocial
//
//  Created by Jake Correnti on 5/25/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

class BadgeButton: UIButton {
	
    // -----------------------------------------
    // MARK: Properties
    // -----------------------------------------
	
	var image: UIImage! {
		didSet {
			setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
		}
	}
	
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
	
	private lazy var badge: UIView = {
		let view = UIView()
		view.isHidden = true 
		view.backgroundColor = UIColor(named: ColorNames.destructiveRed)
		view.layer.cornerRadius = 10
		return view
	}()
	
	
    // -----------------------------------------
    // MARK: Initialization
    // -----------------------------------------
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		setupUI()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		
		setupUI()
	}
	
    // -----------------------------------------
    // MARK: Setup UI
    // -----------------------------------------
	
	private func setupUI() {
		addSubview(badge)
		constrainBadge()
	}
	
	private func constrainBadge() {
		badge.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			badge.centerXAnchor.constraint(equalTo: trailingAnchor),
			badge.centerYAnchor.constraint(equalTo: topAnchor),
			badge.heightAnchor.constraint(equalToConstant: 20),
			badge.widthAnchor.constraint(equalToConstant: 20)
		])
	}
}
