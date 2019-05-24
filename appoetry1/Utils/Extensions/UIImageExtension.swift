//
//  UIImageExtension.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 16.05.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

extension UIImage {
    
    static var post_default: UIImage? {
        return UIImage(named: "default_beach")
    }
    
    static var user_default: UIImage? {
        return UIImage(named: "default")
    }
    
    static var favorite: UIImage? {
        return UIImage(named: "fav-1")
    }
    
    static var unfavorite: UIImage? {
        return UIImage(named: "unfav-1")
    }
    
    static var create_new: UIImage? {
        return UIImage(named: "create_new")
    }
    
    static var mainFeed: UIImage? {
        return UIImage(named: "for_you")
    }
    
    static var search: UIImage? {
        return UIImage(named: "search")
    }
    
    static var favoriteFeed: UIImage? {
        return UIImage(named: "star")
    }
    
    static var profile: UIImage? {
        return UIImage(named: "user_male")
    }
    
    static var logo: UIImage? {
        return UIImage(named: "appoetry")
    }
    
    static var transparent: UIImage? {
        return UIImage(named: "transparent")
    }
}
