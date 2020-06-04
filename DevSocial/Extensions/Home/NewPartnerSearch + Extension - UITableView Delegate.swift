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

        switch section {
		case 2:
			hv.actionButton.addTarget(self, action: #selector(showTechnologyAlert), for: .touchUpInside)
		case 3:
			hv.actionButton.addTarget(self, action: #selector(showContributorAlert), for: .touchUpInside)
		case 4:
			hv.actionButton.addTarget(self, action: #selector(showTagAlert), for: .touchUpInside)
		default:
			break
        }
		
		return hv
    }
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 45
	}
}
