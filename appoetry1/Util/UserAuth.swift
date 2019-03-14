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
    var dateOfBirth: String?
    
    func sendData() -> Any {
        return [
            "username": username,
            "fullName": fullName,
            "firstGenre": firstGenre,
            "secondGenre": secondGenre,
            "thirdGenre": thirdGenre,
            "dateOfBirth": dateOfBirth,
            "email": email
        ]
    }
}
struct UserInfo {
    var fullName: String?
    var username: String?
    var userID: String?
}