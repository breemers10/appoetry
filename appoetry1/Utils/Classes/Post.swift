//
//  Posts.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 15.03.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

final class Post {
    var username: String!
    var userID: String!
    var pathToImage: String!
    var postID: String!
    var favorites: Int!
    var poem: String!
    var genre: String?
    var createdAt: Date?
    var timestamp: Double! {
        didSet {
            createdAt = Date(timeIntervalSince1970: timestamp / 1000)
        }
    }
    var peopleFavorited: [String] = [String]()
}
