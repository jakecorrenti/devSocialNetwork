//
//  TabController.swift
//  DevSocial
//
//  Created by Jake Correnti on 3/29/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit
import Firebase

class TabController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let home = UINavigationController(rootViewController: HomeVC())
        home.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: TabImages.home), tag: 0)
        
        let explore = UINavigationController(rootViewController: ExploreVC())
        explore.tabBarItem = UITabBarItem(title: "Explore", image: UIImage(systemName: TabImages.explore), tag: 1)
        
        let activity = UINavigationController(rootViewController: ActivityVC())
        activity.tabBarItem = UITabBarItem(title: "Activity", image: UIImage(systemName: TabImages.activity), tag: 2)
        
        let profile = UINavigationController(rootViewController: ProfileVC())
        profile.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: TabImages.profile), tag: 3)
        
        viewControllers = [home, explore, activity, profile]
        
        updateFCMToken()
    }
    
    private func updateFCMToken() {
        FirebaseStorageContext.shared.updateFCMToken { (error) in
            if let error = error {
                Alert.showBasicAlert(on: self, with: "Oh no!", message: "please restart your app, there was an error")
            }
        }
    }
}
