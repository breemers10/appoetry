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
    
    var posts = [Post]()
    var usersPosts = [String]()
    
     init(idx: String) {
        self.idx = idx
        getUsername()
        
    }
    
    func getUsersProfile() {
        AppDelegate.instance().showActivityIndicator()
        
        MySharedInstance.instance.ref.child("users").child(idx).queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            _ = snapshot.value as! [String : AnyObject]
            
            self.usersPosts.append(self.idx)
            AppDelegate.instance().dismissActivityIndicator()
        })
        
        MySharedInstance.instance.ref.child("posts").queryOrdered(byChild: "createdAt").observeSingleEvent(of: .value, with: { (snap) in
            let postSnap = snap.value as! [String: AnyObject]
            
            for (_,post) in postSnap {
                if let userID = post["userID"] as? String {
                    for each in self.usersPosts {
                        if each == userID {
                            let posst = Post()
                            if let author = post["author"] as? String, let favourites = post["favourites"] as? Int, let pathToImage = post["pathToImage"] as? String, let postID = post["postID"] as? String, let poem = post["poem"] as? String, let genre = post["genre"] as? String, let createdAt = post["createdAt"] as? Double {
                                posst.username = author
                                posst.favourites = favourites
                                posst.pathToImage = pathToImage
                                posst.postID = postID
                                posst.userID = userID
                                posst.poem = poem
                                posst.genre = genre
                                posst.timestamp = createdAt
                                
                                if let people = post["peopleFavourited"] as? [String : AnyObject] {
                                    for (_,person) in people {
                                        posst.peopleFavourited.append(person as! String)
                                    }
                                }
                                self.posts.append(posst)
                            }
                        }
                    }
                    AppDelegate.instance().dismissActivityIndicator()
                }
            }
        })
        MySharedInstance.instance.ref.removeAllObservers()
    }
    
    func getUsername() {
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
