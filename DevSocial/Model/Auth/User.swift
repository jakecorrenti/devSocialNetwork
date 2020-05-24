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
    let username    : String
    let email       : String
    let dateCreated : Timestamp
    let id          : String
    let fcmToken    : String?
    let headline    : String
	let isLoggedIn  : Bool
	var dictionary  : [String : Any] {
		return [
			"username"    : username,
			"email"       : email,
			"dateCreated" : dateCreated,
			"id" 		  : id,
			"fcmToken"    : fcmToken,
			"isLoggedIn"  : isLoggedIn
		]
	}
}

extension User {
	init? (dictionary: [String : Any]) {
		guard let username = dictionary["username"] as? String,
		let email 		   = dictionary["email"] as? String,
		let dateCreated    = dictionary["dateCreated"] as? Timestamp,
		let id 			   = dictionary["id"] as? String,
		let isLoggedIn     = dictionary["isLoggedIn"] as? Bool,
		let fcmToken       = dictionary["fcmToken"] as? String else { return nil }
		// since the headline is not in the database, it would produce nil and not return the object 
		
		self.init(
			username	: username,
			email		: email,
			dateCreated : dateCreated,
			id			: id,
			fcmToken	: fcmToken,
			headline    : "",
			isLoggedIn  : isLoggedIn
		)
	}
}

