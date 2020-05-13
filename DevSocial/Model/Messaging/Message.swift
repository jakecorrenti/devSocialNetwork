//
//  Message.swift
//  DevSocial
//
//  Created by Jake Correnti on 3/31/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit
import FirebaseFirestore

struct Message {
    
    var id         : String
    var content    : String
    var created    : Timestamp
    var senderID   : String
    var senderName : String
    var wasRead    : Bool
    var dictionary : [String : Any] {
        return [
            "id"         : id,
            "content"    : content,
            "created"    : content,
            "senderID"   : senderID,
            "senderName" : senderName
        ]
    }
}

extension Message {
    init? (dictionary: [String : Any]) {
        guard let id 	   = dictionary["id"] as? String,
            let content    = dictionary["content"] as? String,
            let created    = dictionary["created"] as? Timestamp,
            let senderID   = dictionary["senderID"] as? String,
            let wasRead    = dictionary["wasRead"] as? Bool,
            let senderName = dictionary["senderName"] as? String else { return nil }
        
        self.init(
			id         : id,
			content    : content,
			created    : created,
			senderID   : senderID,
			senderName : senderName,
			wasRead	   : wasRead
		)
    }
}
