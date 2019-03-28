//
//  ProfilesViewModel.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 20.03.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit
import Firebase

class ProfilesViewModel {
    var onCreatePostTap: (() -> Void)?
    var onSignOutTap: (() -> Void)?
    var onFollowersButtonTap: (() -> Void)?
    var onFollowingButtonTap: (() -> Void)?

    var idx: String
    
    var databaseService: DatabaseService?

    init(idx: String, databaseService: DatabaseService) {
        self.databaseService = databaseService
        self.idx = idx
    }
    
    func favouritePost(postID: String) {
        databaseService?.favouritePressed(postID: postID)
    }
    
    func unfavouritePost(postID: String) {
        databaseService?.unfavouritePressed(postID: postID)
    }
    
    func getProfilesFeed() {
        databaseService?.loadProfilesFeed(idx: idx)
    }
    
    func getUserInfo() {
        databaseService?.getProfilesInfo(idx: idx)
    }
    
    func createPost() {
        onCreatePostTap?()
    }
}
