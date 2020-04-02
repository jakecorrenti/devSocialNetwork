//
//  Message.swift
//  DevSocial
//
//  Created by Jake Correnti on 3/31/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

struct Message {
    
    var id: String
    var content: String
    var created: String
    var senderID: String
    var senderName: String
    var dictionary: [String : Any] {
        return [
            "id" : id,
            "content" : content,
            "created" : content,
            "senderID" : senderID,
            "senderName" : senderName
        ]
    }
}

extension Message {
    init? (dictionary: [String : Any]) {
        guard let id = dictionary["id"] as? String,
            let content = dictionary["content"] as? String,
            let created = dictionary["created"] as? String,
            let senderID = dictionary["senderID"] as? String,
            let senderName = dictionary["senderName"] as? String else { return nil }
        
        self.init(id: id, content: content, created: created, senderID: senderID, senderName: senderName)
    }
}
