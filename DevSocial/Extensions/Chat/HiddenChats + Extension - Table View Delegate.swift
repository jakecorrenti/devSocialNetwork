//
//  HiddenChats + Extension - Table View Delegate.swift
//  DevSocial
//
//  Created by Jake Correnti on 5/28/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

extension HiddenChatsVC : UITableViewDelegate {
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 65
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
}
