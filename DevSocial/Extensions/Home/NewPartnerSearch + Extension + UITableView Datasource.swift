//
//  NewPartnerSearch + Extension + UITableView Datasource.swift
//  DevSocial
//
//  Created by Jake Correnti on 6/1/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

extension NewPartnerSearchVC: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch indexPath.section {
		case 0:
			let cell = tableView.dequeueReusableCell(withIdentifier: Cells.textFieldCell, for: indexPath) as! TextFieldCell
			cell.backgroundColor = .secondarySystemBackground
			cell.selectionStyle = .none
			return cell
		case 1:
			let cell = tableView.dequeueReusableCell(withIdentifier: Cells.textViewCell, for: indexPath) as! TextViewCell
			cell.backgroundColor = .secondarySystemBackground
			cell.selectionStyle = .none
			return cell
		case 2:
			let cell = tableView.dequeueReusableCell(withIdentifier: Cells.embeddedCollectionViewCell, for: indexPath) as! EmbeddedCollectionViewCell
			cell.backgroundColor = .systemBackground
			cell.selectionStyle = .none
			cell.data = technologies
			return cell
		default:
			return UITableViewCell()
		}
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 5
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		switch section {
		case 0:
			return "Title"
		case 1:
			return "Description"
		case 2:
			return "Technologies"
		case 3:
			return "Current Contributors"
		case 4:
			return "Tags"
		default:
			return ""
		}
	}
}
