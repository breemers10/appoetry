//
//  Posts.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 15.03.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

class Post {
    var username: String!
    var userID: String!
    var pathToImage: String!
    var postID: String!
    var favourites: Int!
    var poem: String!
    var genre: String?
    
    var peopleFavourited: [String] = [String]()
}
