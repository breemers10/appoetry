//
//  Genres.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 16.05.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import Foundation

enum Genres: Int {
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
    
    static var count: Int { return Genres.winter.rawValue + 1 }
    
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
