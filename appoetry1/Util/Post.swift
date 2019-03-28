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
    var createdAt: Date?
    var timestamp: Double! {
        didSet {
            createdAt = Date(timeIntervalSince1970: timestamp / 1000)
        }
    }
    var peopleFavourited: [String] = [String]()
}

struct PostTest {
    var username: String!
    var userID: String!
    var pathToImage: String!
    var postID: String!
    var favourites: Int!
    var poem: String!
    var genre: String?
    var createdAt: Date?
    var timestamp: Double! {
        didSet {
            createdAt = Date(timeIntervalSince1970: timestamp / 1000)
        }
    }
    var peopleFavourited: [String] = [String]()
}
