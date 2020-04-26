//
//  Post.swift
//  DevSocial
//
//  Created by Mikhail Lozovyy on 4/4/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit
import Firebase

struct Post {
    var title: String
    var type: PostType
    
    var desc: String?
    
    var uid: String
    
    var profile: User
    
    var datePosted: Timestamp
    var lastEdited: Timestamp?
    
    var keywords: [String]
    
    // TODO: Need to add the smiley faces numbers (ex: joe liked it, jane loved it, johnny liked it = 2 liked, 1 loved)
}

enum PostType: String {
    case request = "request"
    case search = "search"
    case empty = "empty"
    
    public init?(_ string: String) {
        switch string {
        case "request": self = .request
        case "search": self = .search
        case "empty": self = .empty
        default: return nil
        }
    }
}
