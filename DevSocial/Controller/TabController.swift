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
        
        let home = UINavigationController(rootViewController: HomeVC())
        home.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: TabImages.home), tag: 0)
        
        let explore = ExploreVC()
        explore.tabBarItem = UITabBarItem(title: "Explore", image: UIImage(systemName: TabImages.explore), tag: 1)
        
        let activity = ActivityVC()
        activity.tabBarItem = UITabBarItem(title: "Activity", image: UIImage(systemName: TabImages.activity), tag: 2)
        
        let profile = ProfileVC()
        profile.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: TabImages.profile), tag: 3)
        
        viewControllers = [home, explore, activity, profile]
    }
}
