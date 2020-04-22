//
//  Chat.swift
//  DevSocial
//
//  Created by Jake Correnti on 3/31/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

struct Chat {
    
    var users: [String]
    var hidden: [String]

    var dictionary: [String : Any] {
        return [
            "users"  : users,
            "hidden" : hidden
        ]
    }
}

extension Chat {
    
    init? (dictionary: [String : Any]) {
        guard let chatUsers = dictionary["users"] as? [String]  else { return nil }
        guard let hiddenUsers = dictionary["hidden"] as? [String] else { return nil }
        self.init(users: chatUsers, hidden: hiddenUsers)
    }
}
