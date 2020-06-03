//
// Created by Jake Correnti on 6/2/20.
// Copyright (c) 2020 Jake Correnti. All rights reserved.
//

import UIKit

extension NewPartnerSearchVC: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		
		let hv = CustomTableViewHeader()
		if section >= 2 {
			hv.configure(title: sectionLabels[section], buttonTitle: "Add")
		} else {
			hv.configure(title: sectionLabels[section])
		}
		
		return hv
    }
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 45
	}
}
