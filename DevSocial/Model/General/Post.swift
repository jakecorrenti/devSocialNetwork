//
//  Post.swift
//  DevSocial
//
//  Created by Mikhail Lozovyy on 4/4/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

struct Post {
    var name: String
    var type: PostType
}

enum PostType {
    case request
    case search
}
