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
    var fcmTokens   : [String]
    let headline    : String
	var dictionary  : [String : Any] {
		return [
			"username"    : username,
			"email"       : email,
			"dateCreated" : dateCreated,
			"id" 		  : id,
			"fcmTokens"   : fcmTokens
		]
	}
}

extension User {
	init? (dictionary: [String : Any]) {
		guard let username = dictionary["username"] as? String,
		let email 		   = dictionary["email"] as? String,
		let dateCreated    = dictionary["dateCreated"] as? Timestamp,
		let id 			   = dictionary["id"] as? String,
		let fcmTokens      = dictionary["fcmTokens"] as? [String] else { return nil }
		// since the headline is not in the database, it would produce nil and not return the object 
		
		self.init(
			username	: username,
			email		: email,
			dateCreated : dateCreated,
			id			: id,
			fcmTokens   : fcmTokens,
			headline    : ""
		)
	}
	
	mutating func addToken(token: String) {
		fcmTokens.append(token)
	}
	
	mutating func removeToken(token: String) {
		let index = fcmTokens.firstIndex(of: token)
		if let index = index {
			fcmTokens.remove(at: index)
		}
	}
}

