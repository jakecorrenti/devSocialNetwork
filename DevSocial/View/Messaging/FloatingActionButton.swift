//
//  FloatingActionButton.swift
//  DevSocial
//
//  Created by Jake Correnti on 5/29/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

class FloatingActionButton: UIButton {
	
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
		backgroundColor = UIColor(named: ColorNames.mainColor)
		let symbolConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold, scale: .medium)
		let image = UIImage(systemName: "plus",  withConfiguration: symbolConfig)
		imageView?.tintColor = .white
		image?.withTintColor(.white, renderingMode: .alwaysTemplate)
		setImage(image, for: .normal)
	}
}
