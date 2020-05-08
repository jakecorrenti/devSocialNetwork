//
//  User.swift
//  DevSocial
//
//  Created by Jake Correnti on 3/29/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import Foundation
import Firebase

struct User: Hashable {
    let username: String
    let email: String
    let dateCreated: Timestamp
    let id: String
    let fcmToken: String?
    let headline: String
}

