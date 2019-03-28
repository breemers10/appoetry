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
    
    func getMyProfilePosts() {
        databaseService?.loadMyProfileFeed()
    }
    
    func getUserInfo() {
        databaseService?.getMyProfileInfo()
    }
    
    func favouritePost(postID: String) {
        databaseService?.favouritePressed(postID: postID)
    }
    
    func unfavouritePost(postID: String) {
        databaseService?.unfavouritePressed(postID: postID)
    }
    
    
    func toEditProfile() {
        onEditProfileTap?()
    }
    
    func signOut() {
        onSignOutTap?()
    }
}
