//
//  CapsuleButton.swift
//  DevSocial
//
//  Created by Jake Correnti on 5/30/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

class CapsuleButton: UIButton {
	
    // -----------------------------------------
    // MARK: Initialization
    // -----------------------------------------
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
    // -----------------------------------------
    // MARK: Setup UI
    // -----------------------------------------
	
	func configure(title: String, color: UIColor) {
		setTitle(title, for: .normal)
		setTitleColor(color, for: .normal)
		titleLabel?.font = .boldSystemFont(ofSize: 15)
		backgroundColor = color.withAlphaComponent(0.2)
		let size = CGSize(width: frame.width, height: .infinity)
		let estimatedSize = self.sizeThatFits(size)
		layer.cornerRadius = estimatedSize.height / 2
		widthAnchor.constraint(equalToConstant: estimatedSize.width + 16).isActive = true
	}
}
