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
		let user = allUnmessagedUsers[indexPath.row]
		if !selectedUsers.contains(user) {
			selectedUsers.append(user)
		}
		searchController.isActive = false
		searchController.searchBar.text = ""
		collectionView.reloadData()
		tableView.deselectRow(at: indexPath, animated: true)
	}
}
