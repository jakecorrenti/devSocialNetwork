//
//  Extension  + UITableView.swift
//  DevSocial
//
//  Created by Jake Correnti on 5/10/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

extension UITableView {
	
	func restoreState() {
		self.backgroundView = nil
	}
	
	func setEmtpyState(image: UIImage? = nil, text: String? = nil) {
		let view = EmptyStateView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
		if image != nil {
			view.emptyStateImage.image = image
		}
		
		if text != nil {
			view.emptyStateText.text = text
		}
		
		view.sizeToFit()
		self.backgroundView = view
	}
}
