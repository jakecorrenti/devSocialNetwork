//
//  StorageContext.swift
//  DevSocial
//
//  Created by Jake Correnti on 3/29/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import Foundation

protocol StorageContext {
    // if a class conforms to this protocol, it must use these functions to access the database
    func saveUser(user: User, onError: @escaping (_ error: Error?) -> Void)
    
    func deleteUser(user: User, onError: @escaping (_ error: Error?) -> Void)
    
}
