//
//  NewChat + Extension - TableView Delegate.swift
//  DevSocial
//
//  Created by Jake Correnti on 4/26/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

extension NewChatVC: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let user = userSearchResults[indexPath.row]
		
		if !selectedUsers.contains(user) && selectedUsers.count < 1 {
			selectedUsers.append(user)
		} else {
			Alert.showBasicAlert(on: self, with: "Oh no!", message: "You can select only one user to chat with at this time.")
		}
		
		searchController.isActive       = false
		searchController.searchBar.text = ""
		nextButton.isEnabled 			= true
		collectionView.reloadData()
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 65
	}
}
