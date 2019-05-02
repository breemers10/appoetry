//
//  MyProfileViewModel.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 08.03.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit
import Firebase

class MyProfileViewModel: NSObject {
    var onEditProfileTap: (() -> Void)?
    var onSignOutTap: (() -> Void)?
    var onFollowersButtonTap: ((String) -> Void)?
    var onFollowingButtonTap:((String) -> Void)?
    
    var username: String?
    var email: String?
    var fullName: String?
    var firstGenre: String?
    var secondGenre: String?
    var thirdGenre: String?
    var imageUrl: String?
    
    var databaseService: DatabaseService?
    
    init(databaseService: DatabaseService) {
        self.databaseService = databaseService
    }
    
    func getMyProfilePosts(with completionHandler: @escaping (Bool) -> Void) {
        databaseService?.loadMyProfileFeed(with: { (loaded) in
            if loaded {
                completionHandler(true)
            }
        })
    }
    
    func getUserInfo(with completionHandler: @escaping (Bool) -> Void) {
        databaseService?.getMyProfileInfo(with: { (loaded) in
            if loaded {
                completionHandler(true)
            }
        })
    }
    
    func favoritePost(postID: String, with completionHandler: @escaping (Bool) -> Void) {
        databaseService?.favoritePressed(postID: postID, with: { (favorited) in
            if favorited {
                completionHandler(true)
            }
        })
    }
    
    func unfavoritePost(postID: String, with completionHandler: @escaping (Bool) -> Void) {
        databaseService?.unfavoritePressed(postID: postID, with: { (unfavorited) in
            if unfavorited {
                completionHandler(true)
            }
        })
    }
    
    func toEditProfile() {
        onEditProfileTap?()
    }
    
    func signOut() {
        onSignOutTap?()
    }
}
