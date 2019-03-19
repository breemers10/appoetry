//
//  UserInfo.swift
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
    var imageUrl: String?
    var uid: String?
    
    func sendData() -> Any {
        return [
            "username": username,
            "fullName": fullName,
            "firstGenre": firstGenre,
            "secondGenre": secondGenre,
            "thirdGenre": thirdGenre,
            "dateOfBirth": dateOfBirth,
            "email": email,
            "imageUrl" : imageUrl
        ]
    }
}
struct UserInfo {
    var fullName: String?
    var username: String?
    var userID: String?
    var imageUrl: String?
}

enum Genre: Int {
    case none = 0
    case birthday = 1
    case christmas = 2
    case comedy = 3
    case erotic = 4
    case life = 5
    case love = 6
    case nature = 7
    case nonSense = 8
    case spring = 9
    case summer = 10
    case winter = 11
    
    static var count: Int { return Genre.winter.rawValue + 1 }
    
    var selectedGenre: String {
        switch self {
        case .none: return "-"
        case .birthday: return "Birthday"
        case .christmas: return "Christmas"
        case .comedy: return "Comedy"
        case .erotic: return "Erotic"
        case .life: return "Life"
        case .love: return "Love"
        case .nature: return "Nature"
        case .nonSense: return "Non-sense"
        case .spring: return "Spring"
        case .summer: return"Summer"
        case .winter: return "Winter"
        }
    }
}


