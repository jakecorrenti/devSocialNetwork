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

	convenience init(imageName: String, pointSize: CGFloat = 25) {
		self.init(frame: .zero)

		let symbolConfig = UIImage.SymbolConfiguration(pointSize: pointSize, weight: .bold, scale: .medium)
		let image = UIImage(systemName: imageName,  withConfiguration: symbolConfig)
		image?.withTintColor(.white, renderingMode: .alwaysTemplate)
		setImage(image, for: .normal)
		setupUI()
	}
	
    // -----------------------------------------
    // MARK: Setup UI
    // -----------------------------------------
	
	private func setupUI() {
		backgroundColor = UIColor(named: ColorNames.mainColor)
		imageView?.tintColor = .white
	}
}
