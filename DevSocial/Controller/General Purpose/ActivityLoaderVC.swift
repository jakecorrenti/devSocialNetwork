//
//  ActivityLoaderVC.swift
//  DevSocial
//
//  Created by Jake Correnti on 5/12/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

class ActivityLoaderVC: UIViewController {
	private let spinner    = UIActivityIndicatorView(style: .medium)
	
	override func loadView() {
		let view = UIView()
		view.backgroundColor = UIColor(white: 0, alpha: 0.7)
		view.addSubview(spinner)
		constrainSpinner()
	}
	
	private func constrainSpinner() {
		spinner.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor)
		])
	}
	
	func startSpinning(on vc: UIViewController) {
		vc.addChild(self)
		self.view.frame = vc.view.frame
		vc.view.addSubview(self.view)
		self.didMove(toParent: vc)
		spinner.startAnimating()
	}
	
	func stopSpinning() {
		
	}
}
