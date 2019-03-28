//
//  DatabaseService.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 26.03.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit
import Firebase

class DatabaseService {
    
    var mainPosts = [Post]()
    var favouritePosts = [Post]()
    var myProfilePosts = [Post]()
    var profilesPosts = [Post]()
    
    var postID: String?
    var idx: String?
    var count: Int?
    
    var following = [String]()
    var favouritedPosts = [String]()
    var myPosts = [String]()
    var usersPosts = [String]()
    
    var unfavourited = false
    var favourited = false
    
    func loadMainFeed() {
        AppDelegate.instance().showActivityIndicator()
        
        let uid = Auth.auth().currentUser?.uid
        
        MySharedInstance.instance.ref.child("users").child(uid!).queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            let users = snapshot.value as! [String : AnyObject]
            
            if let followingUsers = users["following"] as? [String : String] {
                for (_,user) in followingUsers {
                    self.following.append(user)
                }
            }
            self.following.append(uid!)
            AppDelegate.instance().dismissActivityIndicator()
        })
        
        MySharedInstance.instance.ref.child("posts").queryOrdered(byChild: "createdAt").observeSingleEvent(of: .value, with: { (snap) in
            let postSnap = snap.value as! [String: AnyObject]
            
            for (_,post) in postSnap {
                if let userID = post["userID"] as? String {
                    for each in self.following {
                        if each == userID {
                            self.idx = each
                            let mainFeedPosts = Post()
                            mainFeedPosts.username = post["author"] as? String
                            mainFeedPosts.favourites = post["favourites"] as? Int
                            mainFeedPosts.pathToImage = post["pathToImage"] as? String
                            mainFeedPosts.postID = post["postID"] as? String
                            mainFeedPosts.userID = userID
                            mainFeedPosts.poem = post["poem"] as? String
                            mainFeedPosts.genre = post["genre"] as? String
                            mainFeedPosts.timestamp = post["createdAt"] as? Double
                            
                            if let people = post["peopleFavourited"] as? [String : AnyObject] {
                                for (_,person) in people {
                                    mainFeedPosts.peopleFavourited.append(person as! String)
                                }
                            }
                            self.mainPosts.append(mainFeedPosts)
                        }
                    }
                    AppDelegate.instance().dismissActivityIndicator()
                }
            }
        })
        MySharedInstance.instance.ref.removeAllObservers()
    }
    
    func loadFavouriteFeed() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        MySharedInstance.instance.ref.child("users").child(uid).queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            let snap = snapshot.value as! [String : AnyObject]
            
            if let favouritedPosts = snap["favouritedPosts"] as? [String : String] {
                for (_,user) in favouritedPosts {
                    self.favouritedPosts.append(user)
                }
            }
        })
        
        MySharedInstance.instance.ref.child("posts").observeSingleEvent(of: .value, with: { (snap) in
            let postSnap = snap.value as! [String: AnyObject]
            for (_,post) in postSnap {
                if let postID = post["postID"] as? String {
                    for each in self.favouritedPosts {
                        if each == postID {
                            let favouritePost = Post()
                            favouritePost.username = post["author"] as? String
                            favouritePost.favourites = post["favourites"] as? Int
                            favouritePost.pathToImage = post["pathToImage"] as? String
                            favouritePost.postID = postID
                            favouritePost.userID = post["userID"] as? String
                            favouritePost.poem = post["poem"] as? String
                            favouritePost.genre = post["genre"] as? String
                            favouritePost.timestamp = post["createdAt"] as? Double
                            
                            if let people = post["peopleFavourited"] as? [String : AnyObject] {
                                for (_,person) in people {
                                    favouritePost.peopleFavourited.append(person as! String)
                                }
                            }
                            self.favouritePosts.append(favouritePost)
                        }
                    }
                }
            }
        })
        MySharedInstance.instance.ref.removeAllObservers()
    }
    
    func loadMyProfileFeed() {
        let uid = Auth.auth().currentUser?.uid
        
        MySharedInstance.instance.ref.child("users").child(uid!).queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            _ = snapshot.value as! [String : AnyObject]
            
            self.myPosts.append(uid!)
        })
        
        MySharedInstance.instance.ref.child("posts").queryOrdered(byChild: "createdAt").observeSingleEvent(of: .value, with: { (snap) in
            let postSnap = snap.value as! [String: AnyObject]
            
            for (_,post) in postSnap {
                if let userID = post["userID"] as? String {
                    for each in self.myPosts {
                        if each == userID {
                            self.idx = each
                            let myProfilePost = Post()
                            myProfilePost.username = post["author"] as? String
                            myProfilePost.favourites = post["favourites"] as? Int
                            myProfilePost.pathToImage = post["pathToImage"] as? String
                            myProfilePost.postID = post["postID"] as? String
                            myProfilePost.userID = userID
                            myProfilePost.poem = post["poem"] as? String
                            myProfilePost.genre = post["genre"] as? String
                            myProfilePost.timestamp = post["createdAt"] as? Double
                            
                            if let people = post["peopleFavourited"] as? [String : AnyObject] {
                                for (_,person) in people {
                                    myProfilePost.peopleFavourited.append(person as! String)
                                }
                            }
                            self.myProfilePosts.append(myProfilePost)
                        }
                    }
                }
            }
        })
        MySharedInstance.instance.ref.removeAllObservers()
    }
    
    func loadProfilesFeed() {
        MySharedInstance.instance.ref.child("users").child(idx!).queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            _ = snapshot.value as! [String : AnyObject]
            
            self.usersPosts.append(self.idx!)
            
        })
        
        MySharedInstance.instance.ref.child("posts").queryOrdered(byChild: "createdAt").observeSingleEvent(of: .value, with: { (snap) in
            let postSnap = snap.value as! [String: AnyObject]
            
            for (_,post) in postSnap {
                if let userID = post["userID"] as? String {
                    for each in self.usersPosts {
                        if each == userID {
                            let usersPost = Post()
                            usersPost.username = post["author"] as? String
                            usersPost.favourites = post["favourites"] as? Int
                            usersPost.pathToImage = post["pathToImage"] as? String
                            usersPost.postID = post["postID"] as? String
                            usersPost.userID = userID
                            usersPost.poem = post["poem"] as? String
                            usersPost.genre = post["genre"] as? String
                            usersPost.timestamp = post["createdAt"] as? Double
                            
                            if let people = post["peopleFavourited"] as? [String : AnyObject] {
                                for (_,person) in people {
                                    usersPost.peopleFavourited.append(person as! String)
                                }
                            }
                            self.profilesPosts.append(usersPost)
                        }
                    }
                }
            }
        })
        MySharedInstance.instance.ref.removeAllObservers()
    }
    
    func favouritePressed(postID: String) {
        let keyToPost = MySharedInstance.instance.ref.child("posts").childByAutoId().key!
        let keyToUsers = MySharedInstance.instance.ref.child("users").childByAutoId().key!
        guard let id = Auth.auth().currentUser?.uid else { return }
        
        MySharedInstance.instance.ref.child("users").child(id).observeSingleEvent(of: .value, with: { (snap) in
            if let _ = snap.value as? [String : AnyObject] {
                let updateFavouritedPosts: [String : Any] = ["favouritedPosts/\(keyToUsers)" : postID]
                MySharedInstance.instance.ref.child("users").child(id).updateChildValues(updateFavouritedPosts, withCompletionBlock: { (error, ref) in
                    if error == nil {
                        print("all gucci")
                    }
                })
            }
        })
        
        MySharedInstance.instance.ref.child("posts").child(postID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? [String: AnyObject] {
                let updateFavourites: [String : Any] = [ "peopleFavourited/\(keyToPost)" : id]
                MySharedInstance.instance.ref.child("posts").child(postID).updateChildValues(updateFavourites, withCompletionBlock: { (error, ref) in
                    if error == nil {
                        MySharedInstance.instance.ref.child("posts").child(postID).observeSingleEvent(of: .value, with: { (snap) in
                            if let properties = snap.value as? [String : AnyObject] {
                                if let favourites = properties["peopleFavourited"] as? [String : AnyObject] {
                                    let count = favourites.count
                                    self.count = count
                                    
                                    let update = ["favourites" : count]
                                    MySharedInstance.instance.ref.child("posts").child(postID).updateChildValues(update)
                                    self.favourited = true
                                }
                            }
                        })
                    }
                })
            }
        })
        MySharedInstance.instance.ref.removeAllObservers()
        self.favourited = false
    }
    
    func unfavouritePressed(postID: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        MySharedInstance.instance.ref.child("users").child(uid).observeSingleEvent(of: .value, with: { (snap) in
            if let favouritedPosts = snap.value as? [String : AnyObject] {
                if let favourites = favouritedPosts["favouritedPosts"] as? [String : AnyObject] {
                    
                    for (id, post) in favourites {
                        if post as? String == postID {
                            MySharedInstance.instance.ref.child("users").child(uid).child("favouritedPosts").child(id).removeValue(completionBlock: { (error, ref) in
                                if error == nil {
                                    print("all gucci")
                                }
                            })
                        }
                    }
                }
            }
        })
        
        MySharedInstance.instance.ref.child("posts").child(postID).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let properties = snapshot.value as? [String : AnyObject] {
                if let peopleFavourited = properties["peopleFavourited"] as? [String : AnyObject] {
                    
                    for (id, person) in peopleFavourited {
                        if person as? String == Auth.auth().currentUser!.uid {
                            MySharedInstance.instance.ref.child("posts").child(postID).child("peopleFavourited").child(id).removeValue(completionBlock: { (error, ref) in
                                if error == nil {
                                    MySharedInstance.instance.ref.child("posts").child(postID).observeSingleEvent(of: .value, with: { (snap) in
                                        if let prop = snap.value as? [String : AnyObject] {
                                            if let favourites = prop["peopleFavourited"] as? [String : AnyObject] {
                                                let count = favourites.count
                                                self.count = count
                                                MySharedInstance.instance.ref.child("posts").child(postID).updateChildValues(["favourites" : count]) } else {
                                                self.count = 0
                                                MySharedInstance.instance.ref.child("posts").child(postID).updateChildValues(["favourites" : 0])
                                            }
                                        }
                                    })
                                }
                            })
                            self.unfavourited = true
                        }
                    }
                }
            }
        })
        self.unfavourited = false
    }
}