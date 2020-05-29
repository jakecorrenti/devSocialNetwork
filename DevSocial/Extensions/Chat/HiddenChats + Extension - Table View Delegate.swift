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
	
	func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let unhideAction = UIContextualAction(style: .normal, title: "Unhide") { [weak self] (_, _, completionHandler) in
			guard let self = self else { return }
			self.showLoadingView()
			MessagesManager.shared.unhideChat(with: self.getHiddenUsers()[indexPath.row], at: self.getHiddenChatDocuments()[indexPath.row], onSuccess: { [weak self] in
				self?.dismiss(animated: true, completion: nil)
				self?.dismissLoadingView()
				completionHandler(true)
			}) { [weak self] (error) in
				guard let self = self else { return }
				if let error = error {
					Alert.showBasicAlert(on: self, with: error.localizedDescription)
				}
			}
		}
		
		unhideAction.backgroundColor = .systemGreen
		let configuration = UISwipeActionsConfiguration(actions: [unhideAction])
		return configuration
	}
}
