//
//  ProfilesViewModel.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 20.03.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

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
    
    func favouritePost(postID: String, with completionHandler: @escaping (Bool) -> Void) {
        databaseService?.favouritePressed(postID: postID, with: { (favorited) in
            if favorited {
                completionHandler(true)
            }
        })
    }
    
    func unfavouritePost(postID: String, with completionHandler: @escaping (Bool) -> Void) {
        databaseService?.unfavouritePressed(postID: postID, with: { (unfavorited) in
            if unfavorited {
                completionHandler(true)
            }
        })
    }
    
    func getProfilesFeed(with completionHandler: @escaping (Bool) -> Void) {
        databaseService?.loadProfilesFeed(idx: idx, with: { (loaded) in
            if loaded {
                completionHandler(true)
            }
        })
    }
    
    func getUserInfo(with completionHandler: @escaping (Bool) -> Void) {
        databaseService?.getProfilesInfo(idx: idx, with: { (loaded) in
            if loaded {
                completionHandler(true)
            }
        })
    }
    
    func followUser(with completionHandler: @escaping (Bool) -> Void) {
        databaseService?.follow(idx: idx, with: { (hasFollowed) in
            if hasFollowed {
                completionHandler(true)
            }
        })
    }
    
    func unfollowUser(with completionHandler: @escaping (Bool) -> Void) {
        databaseService?.unfollow(idx: idx, with: { (hasUnfollowed) in
            if hasUnfollowed {
                completionHandler(true)
            }
        })
    }
    
    func checkFollowings() {
        databaseService?.checkFollowingStatus(idx: idx)
    }
    
    func createPost() {
        onCreatePostTap?()
    }
}
