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
    static let instance = DatabaseService()
    
    var ref = Database.database().reference()
    let storageRef = Storage.storage().reference()
    
    var mainPosts = [Post]()
    var favouritePosts = [Post]()
    var myProfilePosts = [Post]()
    var profilesPosts = [Post]()
    var userInfoArr = [UserInfo]()
    
    var userRegister = UserRegister()
    var userInfo = UserInfo()
    
    var postID: String?
    var idx: String?
    var count: Int?
    var followings: String?
    var followers: String?
    
    var following = [String]()
    var favouritedPosts = [String]()
    var myPosts = [String]()
    var usersPosts = [String]()
    
    var unfavourited = false
    var favourited = false
    var isCurrentUser = false
    var hasFollowed = false
    var hasUnfollowed = false
    var followed = false
    var hasBeenRegistered = false
    
    func registerUser() {
        guard
            let email = userRegister.email,
            let password = userRegister.password
            else { return }
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if user != nil {
                print("User has signed up")
            }
            guard error == nil else { return }
            guard let uid = Auth.auth().currentUser?.uid else { return }
            self.ref.child("users").child(uid).setValue(self.userRegister.sendData())
            self.hasBeenRegistered = true
        }
    }
    
    func loadMainFeed() {
        AppDelegate.instance().showActivityIndicator()
        
        let uid = Auth.auth().currentUser?.uid
        
        ref.child("users").child(uid!).queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            let users = snapshot.value as! [String : AnyObject]
            
            if let followingUsers = users["following"] as? [String : String] {
                for (_,user) in followingUsers {
                    self.following.append(user)
                }
            }
            self.following.append(uid!)
            AppDelegate.instance().dismissActivityIndicator()
        })
        
        ref.child("posts").queryOrdered(byChild: "createdAt").observeSingleEvent(of: .value, with: { (snap) in
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
        ref.removeAllObservers()
    }
    
    func loadFavouriteFeed() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        ref.child("users").child(uid).queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            let snap = snapshot.value as! [String : AnyObject]
            
            if let favouritedPosts = snap["favouritedPosts"] as? [String : String] {
                for (_,user) in favouritedPosts {
                    self.favouritedPosts.append(user)
                }
            }
        })
        
        ref.child("posts").observeSingleEvent(of: .value, with: { (snap) in
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
        ref.removeAllObservers()
    }
    
    func loadMyProfileFeed() {
        let uid = Auth.auth().currentUser?.uid
        
        ref.child("users").child(uid!).queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            _ = snapshot.value as! [String : AnyObject]
            
            self.myPosts.append(uid!)
        })
        
        ref.child("posts").queryOrdered(byChild: "createdAt").observeSingleEvent(of: .value, with: { (snap) in
            let postSnap = snap.value as! [String: AnyObject]
            
            for (_,post) in postSnap {
                if let userID = post["userID"] as? String {
                    for each in self.myPosts {
                        if each == userID {
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
        ref.removeAllObservers()
    }
    
    func loadProfilesFeed(idx: String) {
        usersPosts.removeAll()
        profilesPosts.removeAll()
        ref.child("users").child(idx).queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            _ = snapshot.value as! [String : AnyObject]
            
            self.usersPosts.append(idx)
        })
        
        ref.child("posts").queryOrdered(byChild: "createdAt").observeSingleEvent(of: .value, with: { (snap) in
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
        ref.removeAllObservers()
    }
    
    func getMyProfileInfo() {
        guard let id = Auth.auth().currentUser?.uid else { return }
        ref.child("users").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
            let usersObject = snapshot.value as? NSDictionary
            
            self.userInfo.username = usersObject?["username"] as? String
            self.userInfo.email = usersObject?["email"] as? String
            self.userInfo.fullName = usersObject?["fullName"] as? String
            self.userInfo.firstGenre = usersObject?["firstGenre"] as? String
            self.userInfo.secondGenre = usersObject?["secondGenre"] as? String
            self.userInfo.thirdGenre = usersObject?["thirdGenre"] as? String
            self.userInfo.imageUrl = usersObject?["imageUrl"] as? String
        })
    }
    
    func getProfilesInfo(idx: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        ref.child("users").child(idx).observeSingleEvent(of: .value, with: { (snapshot) in
            let usersObject = snapshot.value as? NSDictionary
            
            self.userInfo.username = usersObject?["username"] as? String
            self.userInfo.email = usersObject?["email"] as? String
            self.userInfo.fullName = usersObject?["fullName"] as? String
            self.userInfo.firstGenre = usersObject?["firstGenre"] as? String
            self.userInfo.secondGenre = usersObject?["secondGenre"] as? String
            self.userInfo.thirdGenre = usersObject?["thirdGenre"] as? String
            self.userInfo.imageUrl = usersObject?["imageUrl"] as? String
            if idx == uid {
                self.isCurrentUser = true
            }
        })
    }
    
    func searchUsers() {
        userInfoArr = []
        
        guard let id = Auth.auth().currentUser?.uid else { return }
        ref.child("users").observe(.childAdded, with: { (snapshot) in
            guard snapshot.key != id else { return }
            let usersObject = snapshot.value as? NSDictionary
            
            var userInfo = UserInfo()
            userInfo.fullName = usersObject?["username"] as? String
            userInfo.username = usersObject?["fullName"] as? String
            userInfo.imageUrl = usersObject?["imageUrl"] as? String
            userInfo.userID = snapshot.key
            
            self.userInfoArr.append(userInfo)
        })
    }
    
    func getFollowings(idx: String) {
        userInfoArr = []
        
        ref.child("users").child(idx).child("following").observe(.childAdded, with: { (snapshot) in
            self.followings = snapshot.value as? String
            
            self.ref.child("users").child(self.followings!).observeSingleEvent(of: .value, with: { (snap) in
                let usersObject = snap.value as? NSDictionary
                
                var userInfo = UserInfo()
                userInfo.fullName = usersObject?["username"] as? String
                userInfo.username = usersObject?["fullName"] as? String
                userInfo.imageUrl = usersObject?["imageUrl"] as? String
                userInfo.userID = snap.key
                
                self.userInfoArr.append(userInfo)
            })
        })
    }
    
    func getFollowers(idx: String) {
        userInfoArr = []
        
        ref.child("users").child(idx).child("followers").observe(.childAdded, with: { (snapshot) in
            self.followers = snapshot.value as? String
            
            self.ref.child("users").child(self.followers!).observeSingleEvent(of: .value, with: { (snap) in
                let usersObject = snap.value as? NSDictionary
                
                var userInfo = UserInfo()
                userInfo.fullName = usersObject?["username"] as? String
                userInfo.username = usersObject?["fullName"] as? String
                userInfo.imageUrl = usersObject?["imageUrl"] as? String
                userInfo.userID = snap.key
                
                self.userInfoArr.append(userInfo)
            })
        })
    }
    
    func favouritePressed(postID: String) {
        let keyToPost = ref.child("posts").childByAutoId().key!
        let keyToUsers = ref.child("users").childByAutoId().key!
        guard let id = Auth.auth().currentUser?.uid else { return }
        
        ref.child("users").child(id).observeSingleEvent(of: .value, with: { (snap) in
            if let _ = snap.value as? [String : AnyObject] {
                let updateFavouritedPosts: [String : Any] = ["favouritedPosts/\(keyToUsers)" : postID]
                self.ref.child("users").child(id).updateChildValues(updateFavouritedPosts, withCompletionBlock: { (error, ref) in
                    if error == nil {
                        print("all gucci")
                    }
                })
            }
        })
        
        ref.child("posts").child(postID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? [String: AnyObject] {
                let updateFavourites: [String : Any] = [ "peopleFavourited/\(keyToPost)" : id]
                self.ref.child("posts").child(postID).updateChildValues(updateFavourites, withCompletionBlock: { (error, ref) in
                    if error == nil {
                        ref.child("posts").child(postID).observeSingleEvent(of: .value, with: { (snap) in
                            if let properties = snap.value as? [String : AnyObject] {
                                if let favourites = properties["peopleFavourited"] as? [String : AnyObject] {
                                    let count = favourites.count
                                    self.count = count
                                    
                                    let update = ["favourites" : count]
                                    ref.child("posts").child(postID).updateChildValues(update)
                                    self.favourited = true
                                }
                            }
                        })
                    }
                })
            }
        })
        ref.removeAllObservers()
        self.favourited = false
    }
    
    func unfavouritePressed(postID: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        ref.child("users").child(uid).observeSingleEvent(of: .value, with: { (snap) in
            if let favouritedPosts = snap.value as? [String : AnyObject] {
                if let favourites = favouritedPosts["favouritedPosts"] as? [String : AnyObject] {
                    
                    for (id, post) in favourites {
                        if post as? String == postID {
                            self.ref.child("users").child(uid).child("favouritedPosts").child(id).removeValue(completionBlock: { (error, ref) in
                                if error == nil {
                                    print("all gucci")
                                }
                            })
                        }
                    }
                }
            }
        })
        
        ref.child("posts").child(postID).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let properties = snapshot.value as? [String : AnyObject] {
                if let peopleFavourited = properties["peopleFavourited"] as? [String : AnyObject] {
                    
                    for (id, person) in peopleFavourited {
                        if person as? String == Auth.auth().currentUser!.uid {
                            self.ref.child("posts").child(postID).child("peopleFavourited").child(id).removeValue(completionBlock: { (error, ref) in
                                if error == nil {
                                    ref.child("posts").child(postID).observeSingleEvent(of: .value, with: { (snap) in
                                        if let prop = snap.value as? [String : AnyObject] {
                                            if let favourites = prop["peopleFavourited"] as? [String : AnyObject] {
                                                let count = favourites.count
                                                self.count = count
                                                ref.child("posts").child(postID).updateChildValues(["favourites" : count]) } else {
                                                self.count = 0
                                                ref.child("posts").child(postID).updateChildValues(["favourites" : 0])
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
    
    func follow(idx: String) {
        let key = DatabaseService.instance.ref.child("users").childByAutoId().key
        let uid = Auth.auth().currentUser!.uid
        let following = ["following/\(key!)" : idx]
        let followers = ["followers/\(key!)" : uid]
        
        ref.child("users").child(uid).updateChildValues(following)
        ref.child("users").child(idx).updateChildValues(followers)
        
        hasFollowed = true
    }
    
    func unfollow(idx: String) {
        let uid = Auth.auth().currentUser!.uid
        ref.child("users").child(uid).child("following").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
            if let following = snapshot.value as? [String : AnyObject] {
                for (ke, value) in following {
                    if value as? String == idx {
                        
                        self.ref.child("users").child(uid).child("following/\(ke)").removeValue()
                        self.ref.child("users").child(idx).child("followers/\(ke)").removeValue()
                    }
                    self.hasUnfollowed = true
                }
            }
        })
    }
    
    func checkFollowingStatus(idx: String) {
        let uid = Auth.auth().currentUser!.uid
        
        DatabaseService.instance.ref.child("users").child(uid).child("following").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
            if let following = snapshot.value as? [String : AnyObject] {
                for (_, value) in following {
                    if value as? String == idx {
                        self.followed = true
                    }
                }
            }
        })
        DatabaseService.instance.ref.removeAllObservers()
    }
}
