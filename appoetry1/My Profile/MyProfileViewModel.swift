//
//  MyProfileViewModel.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 08.03.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

final class MyProfileViewModel {
    
    var onEditProfileTap: (() -> Void)?
    var onSignOutTap: (() -> Void)?
    var onEditPostTap: ((String) -> Void)?
    var onFollowersButtonTap: ((String) -> Void)?
    var onFollowingButtonTap: ((String) -> Void)?
    var onPostTap: ((String) -> Void)?
    var reloadAtIndex: ((Int) -> Void)?

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
    
    func checkIfChanged(with completionHandler: @escaping (Int) -> Void) {
        databaseService?.postChildChanged()
        databaseService?.onProfileFeedChange = { idx in
            completionHandler(idx)
        }
    }
    
    func toEditProfile() {
        onEditProfileTap?()
    }
    
    func signOut() {
        databaseService?.signOut()
        onSignOutTap?()
    }
}
