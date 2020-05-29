//
//  Extension  + UITableView.swift
//  DevSocial
//
//  Created by Jake Correnti on 5/10/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

extension UITableView {
	
	func setEmptyMessagesState() {
		let view = MyMessagesEmptyState(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
		
		view.sizeToFit()
		self.backgroundView = view 
	}
	
	func restoreState() {
		self.backgroundView = nil
	}
	
	func setEmtpyHiddenChatsState() {
		let view = MyMessagesEmptyState(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
		view.emptyStateImage.image = UIImage(named: Images.hiddenChatsEmptyState)
		view.emptyStateText.text = "You currently have no deleted chats to recover"
		
		view.sizeToFit()
		self.backgroundView = view
	}
}
