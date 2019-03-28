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
        super.init()
        getUserInfo()
        
        self.databaseService = databaseService
    }

    func getMyProfilePosts() {
        databaseService?.loadMyProfileFeed()
    }
    
    func getUserInfo() {
        guard let id = Auth.auth().currentUser?.uid else { return }
        MySharedInstance.instance.ref.child("users").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
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
