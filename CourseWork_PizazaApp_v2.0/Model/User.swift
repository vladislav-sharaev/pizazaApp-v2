//
//  User.swift
//  CourseWork_PizazaApp_v2.0
//
//  Created by Vladislav Sharaev on 9/18/20.
//  Copyright © 2020 Vladislav Sharaev. All rights reserved.
//

import Foundation

class AppUser {
    var email: String
    var uid: String
    var role: String?
    
    init(email: String, uid: String, role: String?) {
        self.email = email
        self.uid = uid
        self.role = role
    }
}
