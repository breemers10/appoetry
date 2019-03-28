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
    
    var username: String?
    var email: String?
    var fullName: String?
    var firstGenre: String?
    var secondGenre: String?
    var thirdGenre: String?
    var imageUrl: String?
    var idx: String
    
    var databaseService: DatabaseService?

    init(idx: String, databaseService: DatabaseService) {
        self.databaseService = databaseService
        self.idx = idx

        getUserInfo()
    }
    
    func favouritePost(postID: String) {
        databaseService?.favouritePressed(postID: postID)
    }
    
    func unfavouritePost(postID: String) {
        databaseService?.unfavouritePressed(postID: postID)
    }
    
    func getUsersProfile() {
        databaseService?.loadProfilesFeed()
    }
    
    func getUserInfo() {
        MySharedInstance.instance.ref.child("users").child(idx).observeSingleEvent(of: .value, with: { (snapshot) in
            let usersObject = snapshot.value as? NSDictionary
            
            self.username = usersObject?["username"] as? String
            self.email = usersObject?["email"] as? String
            self.fullName = usersObject?["fullName"] as? String
            self.firstGenre = usersObject?["firstGenre"] as? String
            self.secondGenre = usersObject?["secondGenre"] as? String
            self.thirdGenre = usersObject?["thirdGenre"] as? String
            self.imageUrl = usersObject?["imageUrl"] as? String
        })
    }
    
    func createPost() {
        onCreatePostTap?()
    }
}
