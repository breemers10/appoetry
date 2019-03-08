//
//  UserAuth.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 08.03.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

struct UserRegister {
    var id: String?
    var username: String?
    var fullName: String?
    var email: String?
    var password: String?
    var firstGenre: String?
    var secondGenre: String?
    var thirdGenre: String?
    
    func sendData() -> Any {
        return [
            "username": username,
            "fullName": fullName,
            "firstGenre": firstGenre,
            "secondGenre": secondGenre,
            "thirdGenre": thirdGenre
        ]
    }
}
