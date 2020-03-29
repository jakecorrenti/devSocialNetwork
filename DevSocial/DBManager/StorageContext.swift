//
//  StorageContext.swift
//  DevSocial
//
//  Created by Jake Correnti on 3/29/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import Foundation

protocol StorageContext {
    
    func saveUser(user: User) throws
    
    func deleteUser(user: User) throws 
    
}
