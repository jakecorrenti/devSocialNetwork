//
//  TabController.swift
//  DevSocial
//
//  Created by Jake Correnti on 3/29/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

class TabController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let home = HomeVC()
        home.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: TabImages.home), tag: 0)
        
        viewControllers = [home]
    }
}
