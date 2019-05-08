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
    static var instance = DatabaseService()
    
    var ref = Database.database().reference()
    let storageRef = Storage.storage().reference(forURL : "gs://appoetry1.appspot.com")
    let currentUserID = Auth.auth().currentUser?.uid
    
    var mainPosts = [Post]()
    var favoritePosts = [Post]()
    var myProfilePosts = [Post]()
    var profilesPosts = [Post]()
    var userInfoArr = [UserInfo]()
    
    var userRegister = UserRegister()
    var userInfo = UserInfo()
    var usersPost = Post()
    
    var postID: String?
    var idx: String?
    var count: Int?
    var followings: String?
    var followers: String?
    
    var following = [String]()
    var myPosts = [String]()
    var usersPosts = [String]()
    
    var isCurrentUser = false
    var hasFollowed = false
    var hasUnfollowed = false
    var followed = false
    
    func registerUser(with completionHandler: @escaping ((Bool) -> Void)) {
        guard
            let email = userRegister.email,
            let password = userRegister.password
            else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (user, error) in
            guard error == nil else {
                completionHandler(false)
                return
            }
            guard let uid = Auth.auth().currentUser?.uid else { return }
            self?.ref.child("users").child(uid).setValue(self?.userRegister.sendData())
            completionHandler(true)
        }
    }
    
    func storeUsersPhoto(data: Data, with completionHandler: @escaping (URL) -> Void) {
        let uid = Auth.auth().currentUser!.uid
        let key = DatabaseService.instance.ref.child("posts").childByAutoId().key
        
        let imageRef = storageRef.child("users").child(uid).child("\(key!).jpg")
        
        let uploadTask = imageRef.putData(data, metadata: nil) { (metadata, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            imageRef.downloadURL(completion: { (url, err) in
                if err != nil {
                    print(err!.localizedDescription)
                }
                if let url = url {
                    completionHandler(url)
                }
            })
        }
        uploadTask.resume()
    }
    
    func getUsername(with completionHandler: @escaping (String) -> Void) {
        let uid = Auth.auth().currentUser!.uid
        
        DatabaseService.instance.ref.child("users").child(uid).observe(.childAdded, with: { (snapshot) in
            if snapshot.key == "username" {
                guard let username = snapshot.value as? String else { return }
                
                completionHandler(username)
            }
        })
    }
    
    func storePostPhoto(data: Data, with completionHandler: @escaping (URL, String) -> Void) {
        
        let uid = Auth.auth().currentUser!.uid
        let key = DatabaseService.instance.ref.child("posts").childByAutoId().key
        
        let imageRef = storageRef.child("posts").child(uid).child("\(key!).jpg")
        
        let uploadTask = imageRef.putData(data, metadata: nil) { (metadata, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            imageRef.downloadURL(completion: { (url, err) in
                if err != nil {
                    print(err!.localizedDescription)
                }
                if let url = url {
                    
                    completionHandler(url, key!)
                }
            })
        }
        uploadTask.resume()
    }
    
    func createPost(author: String?, poem: String?, genre: String?, data: Data?) {
        self.getUsername(with: { [weak self] (username) in
            guard let data = data else { return }
            self?.storePostPhoto(data: data) { (url,key)  in
                let feed = ["userID" : DatabaseService.instance.currentUserID as Any,
                            "poem" : poem as Any,
                            "pathToImage" : url.absoluteString,
                            "favourites" : 0,
                            "author" : username,
                            "genre" : genre as Any,
                            "createdAt" : [".sv":"timestamp"],
                            "postID" : key ] as [String : Any]
                let postFeed = ["\(key)" : feed]
                
                DatabaseService.instance.ref.child("posts").updateChildValues(postFeed)
            }
        })
    }
    
    func loadMainFeed(with completionHandler: @escaping (Bool) -> Void) {
        
        let uid = Auth.auth().currentUser?.uid
        
        ref.child("users").child(uid!).queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            let users = snapshot.value as! [String : AnyObject]
            
            if let followingUsers = users["following"] as? [String : String] {
                for (_,user) in followingUsers {
                    self.following.append(user)
                }
            }
            self.following.append(uid!)
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
                            mainFeedPosts.favorites = post["favourites"] as? Int
                            mainFeedPosts.pathToImage = post["pathToImage"] as? String
                            mainFeedPosts.postID = post["postID"] as? String
                            mainFeedPosts.userID = userID
                            mainFeedPosts.poem = post["poem"] as? String
                            mainFeedPosts.genre = post["genre"] as? String
                            mainFeedPosts.timestamp = post["createdAt"] as? Double
                            
                            if let people = post["peopleFavourited"] as? [String : AnyObject] {
                                for (_,person) in people {
                                    mainFeedPosts.peopleFavorited.append(person as! String)
                                }
                            }
                            self.mainPosts.append(mainFeedPosts)
                            completionHandler(true)
                        }
                    }
                }
            }
        })
        ref.removeAllObservers()
    }
    
    func postChildChanged(with completionHandler: @escaping (Bool) -> Void) {
        ref.child("posts").queryOrderedByKey().observe(.childChanged, with: { snapshot in
            let post = snapshot.value as! [String : AnyObject]
            let postID = post["postID"] as! String
            
            var index: Int?
            
            self.mainPosts.enumerated().forEach({ (post) in
                if post.element.postID == postID {
                    index = post.offset
                }
            })
            
            guard let idx = index else {
                completionHandler(false)
                return
            }
            self.mainPosts[idx].username = post["author"] as? String
            self.mainPosts[idx].favorites = post["favourites"] as? Int
            self.mainPosts[idx].pathToImage = post["pathToImage"] as? String
            self.mainPosts[idx].postID = postID
            self.mainPosts[idx].userID = post["userID"] as? String
            self.mainPosts[idx].poem = post["poem"] as? String
            self.mainPosts[idx].genre = post["genre"] as? String
            self.mainPosts[idx].timestamp = post["createdAt"] as? Double
            completionHandler(true)
        })
    }
    
    func favoritesChildAdded(with completionHandler: @escaping (Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        ref.child("users").child(uid).child("favouritedPosts").queryOrderedByKey().observe(.childAdded, with: { snapshot in
            let postID = snapshot.value as! String
            
            self.ref.child("posts").child(postID).observeSingleEvent(of: .value, with: { (snapshot) in
                let postSnap = snapshot.value as! [String: AnyObject]
                let favoritePost = Post()
                
                favoritePost.username = postSnap["author"] as? String
                favoritePost.favorites = postSnap["favourites"] as? Int
                favoritePost.pathToImage = postSnap["pathToImage"] as? String
                favoritePost.postID = postID
                favoritePost.userID = postSnap["userID"] as? String
                favoritePost.poem = postSnap["poem"] as? String
                favoritePost.genre = postSnap["genre"] as? String
                favoritePost.timestamp = postSnap["createdAt"] as? Double
                
                if let people = postSnap["peopleFavourited"] as? [String : AnyObject] {
                    for (_,person) in people {
                        favoritePost.peopleFavorited.append(person as! String)
                    }
                }
                self.favoritePosts.append(favoritePost)
                completionHandler(true)
            })
        })
    }
    
    func loadMyProfileFeed(with completionHandler: @escaping (Bool) -> Void) {
        let uid = Auth.auth().currentUser?.uid
        
        ref.child("users").child(uid!).queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            _ = snapshot.value as! [String : AnyObject]
            
            self.myPosts.append(uid!)
        })
        
        ref.child("posts").queryOrdered(byChild: "createdAt").observeSingleEvent(of: .value, with: { (snap) in
            let postSnap = snap.value as! [String: AnyObject]
            
            for (_, post) in postSnap {
                if let userID = post["userID"] as? String {
                    for each in self.myPosts {
                        if each == userID {
                            let myProfilePost = Post()
                            myProfilePost.username = post["author"] as? String
                            myProfilePost.favorites = post["favourites"] as? Int
                            myProfilePost.pathToImage = post["pathToImage"] as? String
                            myProfilePost.postID = post["postID"] as? String
                            myProfilePost.userID = userID
                            myProfilePost.poem = post["poem"] as? String
                            myProfilePost.genre = post["genre"] as? String
                            myProfilePost.timestamp = post["createdAt"] as? Double
                            
                            if let people = post["peopleFavourited"] as? [String : AnyObject] {
                                for (_,person) in people {
                                    myProfilePost.peopleFavorited.append(person as! String)
                                }
                            }
                            self.myProfilePosts.append(myProfilePost)
                            completionHandler(true)
                        }
                    }
                }
            }
        })
        ref.removeAllObservers()
    }
    
    func loadProfilesFeed(idx: String, with completionHandler: @escaping (Bool) -> Void) {
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
                            usersPost.favorites = post["favourites"] as? Int
                            usersPost.pathToImage = post["pathToImage"] as? String
                            usersPost.postID = post["postID"] as? String
                            usersPost.userID = userID
                            usersPost.poem = post["poem"] as? String
                            usersPost.genre = post["genre"] as? String
                            usersPost.timestamp = post["createdAt"] as? Double
                            
                            if let people = post["peopleFavourited"] as? [String : AnyObject] {
                                for (_,person) in people {
                                    usersPost.peopleFavorited.append(person as! String)
                                }
                            }
                            self.profilesPosts.append(usersPost)
                            completionHandler(true)
                        }
                    }
                }
            }
        })
        ref.removeAllObservers()
    }
    
    func getMyProfileInfo(with completionHandler: @escaping (Bool) -> Void) {
        
        guard let id = Auth.auth().currentUser?.uid else { return }
        ref.child("users").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
            let usersObject = snapshot.value as? NSDictionary
            
            self.userInfo.username = usersObject?["username"] as? String
            self.userInfo.email = usersObject?["email"] as? String
            self.userInfo.fullName = usersObject?["fullName"] as? String
            self.userInfo.firstGenre = usersObject?["firstGenre"] as? String
            self.userInfo.secondGenre = usersObject?["secondGenre"] as? String
            self.userInfo.thirdGenre = usersObject?["thirdGenre"] as? String
            self.userInfo.dateOfBirth = usersObject?["dateOfBirth"] as? String
            self.userInfo.imageUrl = usersObject?["imageUrl"] as? String
            completionHandler(true)
        })
    }
    
    func openPost(idx: String, with completionHandler: @escaping (Bool) -> Void) {
        
        ref.child("posts").child(idx).observeSingleEvent(of: .value, with: { (snap) in
            let postSnap = snap.value as? NSDictionary
            
            self.usersPost.username = postSnap?["author"] as? String
            self.usersPost.favorites = postSnap?["favourites"] as? Int
            self.usersPost.pathToImage = postSnap?["pathToImage"] as? String
            self.usersPost.postID = postSnap?["postID"] as? String
            self.usersPost.userID = postSnap?["userID"] as? String
            self.usersPost.poem = postSnap?["poem"] as? String
            self.usersPost.genre = postSnap?["genre"] as? String
            self.usersPost.timestamp = postSnap?["createdAt"] as? Double
            
            if let people = postSnap?["peopleFavourited"] as? [String : AnyObject] {
                for (_,person) in people {
                    self.usersPost.peopleFavorited.append(person as! String)
                }
            }
            completionHandler(true)
        })
    }
    
    func getProfilesInfo(idx: String, with completionHandler: @escaping (Bool) -> Void) {
        ref.child("users").child(idx).observeSingleEvent(of: .value, with: { (snapshot) in
            let usersObject = snapshot.value as? NSDictionary
            
            self.userInfo.username = usersObject?["username"] as? String
            self.userInfo.email = usersObject?["email"] as? String
            self.userInfo.fullName = usersObject?["fullName"] as? String
            self.userInfo.firstGenre = usersObject?["firstGenre"] as? String
            self.userInfo.secondGenre = usersObject?["secondGenre"] as? String
            self.userInfo.thirdGenre = usersObject?["thirdGenre"] as? String
            self.userInfo.imageUrl = usersObject?["imageUrl"] as? String
            completionHandler(true)
        })
    }
    
    func searchUsers(with completionHandler: @escaping (Bool) -> Void) {
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
            
            completionHandler(true)
        })
    }
    
    func getFollowings(idx: String, with completionHandler: @escaping (Bool) -> Void) {
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
                completionHandler(true)
            })
        })
    }
    
    func getFollowers(idx: String, with completionHandler: @escaping (Bool) -> Void) {
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
                completionHandler(true)
            })
        })
    }
    
    func favoritePressed(postID: String, with completionHandler: @escaping (Bool) -> Void) {
        guard let id = Auth.auth().currentUser?.uid else { return }
        
        let keyToPost = ref.child("posts").child(id).key!
        let keyToUsers = ref.child("users").child(postID).key!
        
        var userUpdateDone = false
        var postUpdateDone = false
        
        func checkIfDone() {
            guard userUpdateDone && postUpdateDone else { return }
            completionHandler(true)
        }
        
        ref.child("users").child(id).observeSingleEvent(of: .value, with: { (snap) in
            
            if let _ = snap.value as? [String : AnyObject] {
                let updateFavouritedPosts: [String : Any] = ["favouritedPosts/\(keyToUsers)" : postID]
                self.ref.child("users").child(id).updateChildValues(updateFavouritedPosts, withCompletionBlock: { (error, ref) in
                    if error == nil {
                        print("all gucci")
                        //                        completionHandler(true)
                        userUpdateDone = true
                        checkIfDone()
                    }
                })
            }
        })
        
        ref.child("posts").child(postID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? [String: AnyObject] {
                let updateFavorites: [String : Any] = [ "peopleFavourited/\(keyToPost)" : id]
                self.ref.child("posts").child(postID).updateChildValues(updateFavorites, withCompletionBlock: { (error, ref) in
                    if error == nil {
                        self.ref.child("posts").child(postID).observeSingleEvent(of: .value, with: { (snap) in
                            if let properties = snap.value as? [String : AnyObject] {
                                if let favorites = properties["peopleFavourited"] as? [String : AnyObject] {
                                    let count = favorites.count
                                    self.count = count
                                    
                                    let update = ["favourites" : count]
                                    self.ref.child("posts").child(postID).updateChildValues(update)
                                    postUpdateDone = true
                                    checkIfDone()
                                    //                                    completionHandler(true)
                                }
                            }
                        })
                    }
                })
            }
        })
        ref.removeAllObservers()
        //        completionHandler(false)
    }
    
    func unfavoritePressed(postID: String, with completionHandler: @escaping (Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var userUpdateDone = false
        var postUpdateDone = false
        
        func checkIfDone() {
            guard userUpdateDone && postUpdateDone else { return }
            completionHandler(true)
        }
        
        ref.child("users").child(uid).child("favouritedPosts").child(postID).removeValue(completionBlock: { (error, ref) in
            userUpdateDone = true
            checkIfDone()
            if error == nil {
                print("all gucci")
            }
        })
        
        ref.child("posts").child(postID).child("peopleFavourited").child(uid).removeValue(completionBlock: { (error, ref) in
            self.mainPosts.first(where: { $0.postID == postID})?.peopleFavorited.removeAll(where: { $0 == uid})
            self.favoritePosts.removeAll(where: { $0.postID == postID})
            if error == nil {
                self.ref.child("posts").child(postID).observeSingleEvent(of: .value, with: { (snap) in
                    if let prop = snap.value as? [String : AnyObject] {
                        if let favorites = prop["peopleFavourited"] as? [String : AnyObject] {
                            let count = favorites.count
                            self.count = count
                            self.ref.child("posts").child(postID).updateChildValues(["favourites" : count]) } else {
                            self.count = 0
                            self.ref.child("posts").child(postID).updateChildValues(["favourites" : 0])
                            postUpdateDone = true
                            checkIfDone()
                            
                        }
                    }
                })
            }
        })
        ref.removeAllObservers()
        //        completionHandler(false)
    }
    
    
    func follow(idx: String, with completionHandler: @escaping (Bool) -> Void) {
        let key = DatabaseService.instance.ref.child("users").childByAutoId().key
        let uid = Auth.auth().currentUser!.uid
        let following = ["following/\(key!)" : idx]
        let followers = ["followers/\(key!)" : uid]
        
        ref.child("users").child(uid).updateChildValues(following)
        ref.child("users").child(idx).updateChildValues(followers)
        
        completionHandler(true)
    }
    
    func unfollow(idx: String, with completionHandler: @escaping (Bool) -> Void) {
        let uid = Auth.auth().currentUser!.uid
        ref.child("users").child(uid).child("following").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
            if let following = snapshot.value as? [String : AnyObject] {
                for (ke, value) in following {
                    if value as? String == idx {
                        
                        self.ref.child("users").child(uid).child("following/\(ke)").removeValue()
                        self.ref.child("users").child(idx).child("followers/\(ke)").removeValue()
                    }
                    completionHandler(true)
                }
            }
        })
    }
    
    func checkFollowingStatus(idx: String, with completionHandler: @escaping (Bool) -> Void) {
        let uid = Auth.auth().currentUser!.uid
        
        DatabaseService.instance.ref.child("users").child(uid).child("following").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
            if let following = snapshot.value as? [String : AnyObject] {
                for (_, value) in following {
                    if value as? String == idx {
                        completionHandler(true)
                    }
                }
            }
        })
        DatabaseService.instance.ref.removeAllObservers()
    }
    
    func deleteAccount() {
        let user = Auth.auth().currentUser
        
        user?.delete(completion: { [weak self] (error) in
            if let error = error {
                print(error)
            } else {
                self?.ref.child("users").child((user?.uid)!).removeValue()
            }
        })
    }
}
