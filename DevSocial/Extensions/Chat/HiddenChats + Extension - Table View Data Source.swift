//
//  HiddenChats + Extension - Table View Data Source.swift
//  DevSocial
//
//  Created by Jake Correnti on 5/28/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

extension HiddenChatsVC: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if getHiddenUsers().count == 0 {
			tableView.setEmtpyState(image: UIImage(named: Images.hiddenChatsEmptyState), text: "You currently have no deleted chats to recover")
		} else {
			tableView.restoreState()
		}
		return getHiddenUsers().count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: Cells.messagedUserCell, for: indexPath) as! MessagedUserCell
		cell.selectedUser = getHiddenUsers()[indexPath.row]
		return cell
	}
}
