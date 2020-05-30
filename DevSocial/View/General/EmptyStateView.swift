//
//  EmptyStateView.swift
//  DevSocial
//
//  Created by Jake Correnti on 5/10/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

class EmptyStateView: UIView {
	
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
	
	lazy var emptyStateImage: UIImageView = {
		let view 		 = UIImageView()
		view.contentMode = .scaleAspectFit
		return view
	}()
	
	lazy var emptyStateText: UILabel = {
		let view 		   = UILabel()
		view.textAlignment = .center
		view.textColor     = UIColor(named: ColorNames.secondaryTextColor)
		view.font 		   = .systemFont(ofSize: 18)
		view.numberOfLines = 0
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
    // MARK: Configure UI
    // -----------------------------------------
	
	private func setupUI() {
		[emptyStateImage, emptyStateText].forEach { addSubview($0) }
		
		constrainImage()
		constrainLabel()
	}
	
	private func constrainImage() {
		emptyStateImage.translatesAutoresizingMaskIntoConstraints = false
		let imageSize = frame.width * 0.75
		NSLayoutConstraint.activate([
			emptyStateImage.centerXAnchor.constraint(equalTo: centerXAnchor),
			emptyStateImage.centerYAnchor.constraint(equalTo: centerYAnchor),
			emptyStateImage.heightAnchor.constraint(equalToConstant: imageSize),
			emptyStateImage.widthAnchor.constraint(equalToConstant: imageSize)
		])
	}
	
	private func constrainLabel() {
		emptyStateText.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			emptyStateText.centerXAnchor.constraint(equalTo: centerXAnchor),
			emptyStateText.topAnchor.constraint(equalTo: emptyStateImage.bottomAnchor, constant: 24),
			emptyStateText.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
			emptyStateText.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24)
		])
	}
}
