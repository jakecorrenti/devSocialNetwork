//
//  NewPostVC Extension + UITableView.swift
//  DevSocial
//
//  Created by Mikhail Lozovyy on 4/20/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

extension NewPostVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        
        switch row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: nameCellID) as! TextFieldCell
            
            cell.textField.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: keywordCellID)!
            
            cell.textLabel!.font = UIFont.systemFont(ofSize: 14)
            cell.textLabel!.textColor = UIColor(named: ColorNames.mainColor)
            cell.textLabel!.text = "iOS, Developers, Open"
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: descCellID) as! TextViewCell
            
            cell.placeholder = "Desc..."
            
            cell.callBack = {
                textView in
                // update data source
//                self.desc = textView.text
                // tell table view we're starting layout updates
                tableView.beginUpdates()
                // get current content offset
                var scOffset = tableView.contentOffset
                // get current text view height
                let tvHeight = textView.frame.size.height
                // telll text view to size itself
                textView.sizeToFit()
                // get the difference between previous height and new height (if word-wrap or newline change)
                let yDiff = textView.frame.size.height - tvHeight
                // adjust content offset
                scOffset.y += yDiff
                // update table content offset so edit caret is not covered by keyboard
                tableView.contentOffset = scOffset
                // tell table view to apply layout updates
                tableView.endUpdates()
            }
            
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
}

