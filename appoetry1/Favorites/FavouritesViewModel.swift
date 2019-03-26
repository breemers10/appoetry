//
//  FavouritesViewModel.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 08.03.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit
import Firebase

class FavouritesViewModel: NSObject {
    var onCreatePostTap: (() -> Void)?
    var posts = [Post]()
    var favouritedPosts = [String]()
    
    func createPost() {
        onCreatePostTap?()
    }
    
    func getFavouritesPosts() {
        AppDelegate.instance().showActivityIndicator()
        
        let uid = Auth.auth().currentUser?.uid
        
        MySharedInstance.instance.ref.child("users").child(uid!).queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            let snap = snapshot.value as! [String : AnyObject]
            
            if let favouritedPosts = snap["favouritedPosts"] as? [String : String] {
                for (_,user) in favouritedPosts {
                    self.favouritedPosts.append(user)
                }
            }
            
            self.favouritedPosts.append(uid!)
            AppDelegate.instance().dismissActivityIndicator()
        })
        
        MySharedInstance.instance.ref.child("posts").queryOrdered(byChild: "createdAt").observeSingleEvent(of: .value, with: { (snap) in
            let postSnap = snap.value as! [String: AnyObject]
            
            for (_,post) in postSnap {
                if
                    let userID = post["userID"] as? String,
                    let postID = post["postID"] as? String {
                    for each in self.favouritedPosts {
                        if each == postID {
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
}
