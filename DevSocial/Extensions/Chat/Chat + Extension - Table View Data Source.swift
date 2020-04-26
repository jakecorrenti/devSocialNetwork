//
//  Chat + Extension - Table View Data Source.swift
//  DevSocial
//
//  Created by Jake Correnti on 4/24/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

extension ChatVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.messageCell, for: indexPath) as! MessageCell
        cell.message = messages[indexPath.section][indexPath.row]
        cell.backgroundColor = UIColor(named: ColorNames.background)
        cell.selectionStyle = .none
        
        if currentUser.uid != messages[indexPath.section][indexPath.row].senderID {
            MessagesManager.shared.updateWasReadState(message: messages[indexPath.section][indexPath.row], docReference: docReference!, osSuccess: { (error) in
                
            }) { (error) in
                if let error = error {
                    Alert.showBasicAlert(on: self, with: "An error occurred", message: error.localizedDescription)
                }
            }
        }
        
        return cell
    }
}
