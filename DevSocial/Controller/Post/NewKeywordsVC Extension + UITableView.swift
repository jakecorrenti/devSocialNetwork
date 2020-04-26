//
//  NewKeywordsVC Extension + UITableView.swift
//  DevSocial
//
//  Created by Mikhail Lozovyy on 4/25/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

extension NewKeywordsVC {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: keywordCellID)
        
        return cell
    }
}
