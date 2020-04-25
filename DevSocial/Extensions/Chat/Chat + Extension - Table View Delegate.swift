//
//  Chat + Extension - Table View Delegate.swift
//  DevSocial
//
//  Created by Jake Correnti on 4/24/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

extension ChatVC: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        
        let sectionDate = formater.string(from: messages[section][0].created.dateValue())
        let currentDate = formater.string(from: Date())
        
        label.text = sectionDate == currentDate ? "Today" : sectionDate
        
        label.textAlignment = .center
        label.backgroundColor = UIColor(named: ColorNames.background)
        label.textColor = .systemGray3
        return label
    }
}
