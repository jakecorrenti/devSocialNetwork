//
//  Extension + CollectionView.swift
//  DevSocial
//
//  Created by Jake Correnti on 4/26/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

extension UICollectionView {
	
	func setEmptyState() {
		let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height))
		
		messageLabel.text = "No user(s) selected \n Search for users to create a chat"
		messageLabel.textAlignment = .center
		
		messageLabel.sizeToFit()
		self.backgroundView = messageLabel
	}
	
	func restorePopulatedState() {
		self.backgroundView = nil
	}
}
