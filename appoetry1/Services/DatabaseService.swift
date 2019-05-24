//
//  DatabaseService.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 26.03.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit
import Firebase

final class DatabaseService: PDatabaseService {
    
    static var instance = DatabaseService()
    
    var ref = Database.database().reference()
    let storageRef = Storage.storage().reference(forURL : "gs://appoetry1.appspot.com")
    let currentUserID = Auth.auth().currentUser?.uid
    private let firebaseAuth = Auth.auth()
    
    var mainPosts = [Post]()
    var myPosts = [Post]()
    var favoritePosts = [Post]()
    var profilePosts = [Post]()

    var userInfoArr = [UserInfo]()
    var loginEmail: LoginEmail?
    
    var onMainFeedChange: ((Int) -> Void)?
    var onFavoriteFeedChange: ((Int) -> Void)?
    var onProfileFeedChange: ((Int) -> Void)?

    var userInfo = UserInfo()
    var usersPost = Post()
    
    var postID: String?
    var idx: String?
    var count: Int?
    var followings: String?
    var followers: String?
    
    var following = [String]()
    var usersPosts = [String]()

    var isCurrentUser = false
    var hasFollowed = false
    var hasUnfollowed = false
    var followed = false
    var isLoggedIn: Bool {
        return firebaseAuth.currentUser != nil
    }
    
    func registerUser(with completionHandler: @escaping ((Bool) -> Void)) {
        guard
            let email = userInfo.email,
            let password = userInfo.password
            else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (user, error) in
            guard error == nil else {
                completionHandler(false)
                return
            }
            guard let uid = Auth.auth().currentUser?.uid else { return }
            self?.ref.child("users").child(uid).setValue(self?.userInfo.sendData())
            completionHandler(true)
        }
    }
    
    func isEmailAlreadyTaken(emailAddressString: String, with completionHandler: @escaping (Bool) -> Void) {
        
        DatabaseService.instance.ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            var isAlreadyUsed = false
            let value = snapshot.value as? [String : AnyObject]
            value?.forEach({ (key, value) in
                guard let email = value["email"] as? String else { return }
                if email == emailAddressString {
                    isAlreadyUsed = true
                }
            })
            completionHandler(isAlreadyUsed)
        })
    }
    
    func isUsernameAlreadyTaken(username: String, with completionHandler: @escaping (Bool) -> Void) {
        DatabaseService.instance.ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            var isAlreadyUsed = false
            let value = snapshot.value as? [String : AnyObject]
            value?.forEach({ (key, value) in
                guard let username1 = value["username"] as? String else { return }
                if username1 == username {
                    isAlreadyUsed = true
                }
            })
            completionHandler(isAlreadyUsed)
        })
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
    
    
    func loginWithEmailAndPassword(with email: String, with password: String, with completionHandler: @escaping ((LoginEmail?, String?) -> Void)) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            guard error == nil else {
                completionHandler(nil, "Wrong credentials")
                return
            }
            self.loginEmail = LoginEmail.init(email: Auth.auth().currentUser?.email)
            completionHandler(self.loginEmail, nil)
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch let err {
            print(err)
        }
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
        guard let key = DatabaseService.instance.ref.child("posts").childByAutoId().key else { return }
        
        let imageRef = storageRef.child("posts").child(uid).child("\(key).jpg")
        
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
                    
                    completionHandler(url, key)
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
    
    func editPost(poem: String, postID: String) {
        ref.child("posts").child(postID).updateChildValues([ "poem" : poem ])
    }
    
    func editCredentials(fullname: String, email: String, firstGenre: String, secondGenre: String, thirdGenre: String, imageUrl: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        
        ref.child("users").child(uid).updateChildValues([ "fullName" : fullname,
                                                          "email" : email,
                                                          "firstGenre" : firstGenre ,
                                                          "secondGenre" : secondGenre,
                                                          "thirdGenre" : thirdGenre,
                                                          "imageUrl" : imageUrl
            ])
    }
    
    func loadMainFeed(with completionHandler: @escaping (Bool) -> Void) {
        mainPosts = []
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        ref.child("users").child(uid).observeSingleEvent(of: .value, with: { [weak self] snapshot in
            let users = snapshot.value as? [String : AnyObject]
            
            if let followingUsers = users?["following"] as? [String : String] {
                for (_,user) in followingUsers {
                    self?.following.append(user)
                }
            }
            self?.following.append(uid)
        })
        
        ref.child("posts").queryOrdered(byChild: "createdAt").observeSingleEvent(of: .value, with: { [weak self] (snap) in
            guard let postSnap = snap.value as? [String: AnyObject] else { return }
            
            for (_,post) in postSnap {
                if let userID = post["userID"] as? String {
                    for each in (self?.following)! {
                        if each == userID {
                            self?.idx = each
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
                            self?.mainPosts.append(mainFeedPosts)
                            
                            completionHandler(true)
                        }
                        self?.mainPosts.sort(by: { (first, second) -> Bool in
                            return first.timestamp > second.timestamp
                        })
                    }
                }
            }
        })
    }
    
    func postChildChanged() {
        ref.child("posts").queryOrderedByKey().observe(.childChanged, with: { [weak self] snapshot in
            let post = snapshot.value as? [String : AnyObject]
            let postID = post?["postID"] as? String
            
            var index: Int?
            var myIndex: Int?
            
            self?.mainPosts.enumerated().forEach({ (post) in
                if post.element.postID == postID {
                    index = post.offset
                }
            })
            
            self?.myPosts.enumerated().forEach({ (post) in
                if post.element.postID == postID {
                    myIndex = post.offset
                }
            })
            
            guard let idx = index else { return }
            guard let myIdx = myIndex else { return }
            
            self?.mainPosts[idx].username = post?["author"] as? String
            self?.mainPosts[idx].favorites = post?["favourites"] as? Int
            self?.mainPosts[idx].pathToImage = post?["pathToImage"] as? String
            self?.mainPosts[idx].postID = postID
            self?.mainPosts[idx].userID = post?["userID"] as? String
            self?.mainPosts[idx].poem = post?["poem"] as? String
            self?.mainPosts[idx].genre = post?["genre"] as? String
            self?.mainPosts[idx].timestamp = post?["createdAt"] as? Double
            
            self?.myPosts[myIdx].username = post?["author"] as? String
            self?.myPosts[myIdx].favorites = post?["favourites"] as? Int
            self?.myPosts[myIdx].pathToImage = post?["pathToImage"] as? String
            self?.myPosts[myIdx].postID = postID
            self?.myPosts[myIdx].userID = post?["userID"] as? String
            self?.myPosts[myIdx].poem = post?["poem"] as? String
            self?.myPosts[myIdx].genre = post?["genre"] as? String
            self?.myPosts[myIdx].timestamp = post?["createdAt"] as? Double
            
            self?.onMainFeedChange?(idx)
            self?.onProfileFeedChange?(myIdx)
            self?.onFavoriteFeedChange?(idx)
        })
    }
    
    func favoritesChildAdded(with completionHandler: @escaping (Bool) -> Void) {
        let uid = Auth.auth().currentUser!.uid
        
        ref.child("users").child(uid).child("favouritedPosts").queryOrderedByKey().observe(.childAdded, with: { [weak self] snapshot in
            guard let postID = snapshot.value as? String else { return }
            
            self?.ref.child("posts").child(postID).observeSingleEvent(of: .value, with: { (snapshot) in
                guard let postSnap = snapshot.value as? [String: AnyObject] else { return }
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
                self?.favoritePosts.append(favoritePost)
                completionHandler(true)
            })
            self?.favoritePosts.sort(by: { (first, second) -> Bool in
                return first.timestamp > second.timestamp
            })
        })
    }
    
    func loadMyProfileFeed(with completionHandler: @escaping (Bool) -> Void) {
        let uid = Auth.auth().currentUser?.uid
        
        ref.child("posts").queryOrdered(byChild: "userID").queryEqual(toValue: uid).observeSingleEvent(of: .value, with: { (snap) in
            let postSnap = snap.value as? [String: AnyObject]
            
            postSnap?.forEach({ [weak self] (_, value) in
                let myProfilePost = Post()
                myProfilePost.username = value["author"] as? String
                myProfilePost.favorites = value["favourites"] as? Int
                myProfilePost.pathToImage = value["pathToImage"] as? String
                myProfilePost.postID = value["postID"] as? String
                myProfilePost.userID = uid
                myProfilePost.poem = value["poem"] as? String
                myProfilePost.genre = value["genre"] as? String
                myProfilePost.timestamp = value["createdAt"] as? Double
                
                if let people = value["peopleFavourited"] as? [String : AnyObject] {
                    for (_,person) in people {
                        myProfilePost.peopleFavorited.append(person as! String)
                    }
                }
                self?.myPosts.append(myProfilePost)
                completionHandler(true)
            })
            self.myPosts.sort(by: { (first, second) -> Bool in
                return first.timestamp > second.timestamp
            })
        })
    }
    
    func loadProfilesFeed(idx: String, with completionHandler: @escaping (Bool) -> Void) {
        usersPosts.removeAll()
        // mainPosts.removeAll()
        ref.child("users").child(idx).queryOrderedByKey().observeSingleEvent(of: .value, with: { [weak self] snapshot in
            _ = snapshot.value as! [String : AnyObject]
            
            self?.usersPosts.append(idx)
        })
        
        ref.child("posts").queryOrdered(byChild: "createdAt").observeSingleEvent(of: .value, with: { [weak self] (snap) in
            guard let postSnap = snap.value as? [String: AnyObject] else { return }
            
            for (_,post) in postSnap {
                if let userID = post["userID"] as? String {
                    for each in (self?.usersPosts)! {
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
                            self?.profilePosts.append(usersPost)
                            completionHandler(true)
                        }
                        
                        self?.profilePosts.sort(by: { (first, second) -> Bool in
                            return first.timestamp > second.timestamp
                        })
                    }
                }
            }
        })
    }
    
    func getMyProfileInfo(with completionHandler: @escaping (Bool) -> Void) {
        
        guard let id = Auth.auth().currentUser?.uid else { return }
        ref.child("users").child(id).observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
            let usersObject = snapshot.value as? NSDictionary
            
            self?.userInfo.username = usersObject?["username"] as? String
            self?.userInfo.email = usersObject?["email"] as? String
            self?.userInfo.fullName = usersObject?["fullName"] as? String
            self?.userInfo.firstGenre = usersObject?["firstGenre"] as? String
            self?.userInfo.secondGenre = usersObject?["secondGenre"] as? String
            self?.userInfo.thirdGenre = usersObject?["thirdGenre"] as? String
            self?.userInfo.dateOfBirth = usersObject?["dateOfBirth"] as? String
            self?.userInfo.imageUrl = usersObject?["imageUrl"] as? String
            completionHandler(true)
        })
    }
    
    func openPost(idx: String, with completionHandler: @escaping (Bool) -> Void) {
        
        ref.child("posts").child(idx).observeSingleEvent(of: .value, with: { [weak self] (snap) in
            let postSnap = snap.value as? NSDictionary
            
            self?.usersPost.username = postSnap?["author"] as? String
            self?.usersPost.favorites = postSnap?["favourites"] as? Int
            self?.usersPost.pathToImage = postSnap?["pathToImage"] as? String
            self?.usersPost.postID = postSnap?["postID"] as? String
            self?.usersPost.userID = postSnap?["userID"] as? String
            self?.usersPost.poem = postSnap?["poem"] as? String
            self?.usersPost.genre = postSnap?["genre"] as? String
            self?.usersPost.timestamp = postSnap?["createdAt"] as? Double
            
            if let people = postSnap?["peopleFavourited"] as? [String : AnyObject] {
                for (_,person) in people {
                    self?.usersPost.peopleFavorited.append(person as! String)
                }
            }
            completionHandler(true)
        })
    }
    
    func getProfilesInfo(idx: String, with completionHandler: @escaping (Bool) -> Void) {
        ref.child("users").child(idx).observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
            let usersObject = snapshot.value as? NSDictionary
            self?.userInfo.userID = snapshot.key
            self?.userInfo.username = usersObject?["username"] as? String
            self?.userInfo.email = usersObject?["email"] as? String
            self?.userInfo.fullName = usersObject?["fullName"] as? String
            self?.userInfo.firstGenre = usersObject?["firstGenre"] as? String
            self?.userInfo.secondGenre = usersObject?["secondGenre"] as? String
            self?.userInfo.thirdGenre = usersObject?["thirdGenre"] as? String
            self?.userInfo.imageUrl = usersObject?["imageUrl"] as? String
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
        
        ref.child("users").child(idx).child("following").observe(.childAdded, with: { [weak self] (snapshot) in
            self?.followings = snapshot.value as? String
            
            self?.ref.child("users").child((self?.followings)!).observeSingleEvent(of: .value, with: { [weak self] (snap) in
                let usersObject = snap.value as? NSDictionary
                
                var userInfo = UserInfo()
                userInfo.fullName = usersObject?["username"] as? String
                userInfo.username = usersObject?["fullName"] as? String
                userInfo.imageUrl = usersObject?["imageUrl"] as? String
                userInfo.userID = snap.key
                
                self?.userInfoArr.append(userInfo)
                completionHandler(true)
            })
        })
    }
    
    func getFollowers(idx: String, with completionHandler: @escaping (Bool) -> Void) {
        userInfoArr = []
        
        ref.child("users").child(idx).child("followers").observe(.childAdded, with: { [weak self] (snapshot) in
            self?.followers = snapshot.value as? String
            
            self?.ref.child("users").child((self?.followers)!).observeSingleEvent(of: .value, with: { [weak self] (snap) in
                let usersObject = snap.value as? NSDictionary
                
                var userInfo = UserInfo()
                userInfo.fullName = usersObject?["username"] as? String
                userInfo.username = usersObject?["fullName"] as? String
                userInfo.imageUrl = usersObject?["imageUrl"] as? String
                userInfo.userID = snap.key
                
                self?.userInfoArr.append(userInfo)
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
        
        ref.child("users").child(id).observeSingleEvent(of: .value, with: { [weak self] (snap) in
            
            if let _ = snap.value as? [String : AnyObject] {
                let updateFavouritedPosts: [String : Any] = ["favouritedPosts/\(keyToUsers)" : postID]
                self?.ref.child("users").child(id).updateChildValues(updateFavouritedPosts, withCompletionBlock: { (error, ref) in
                    if error == nil {
                        print("all gucci")
                        //                        completionHandler(true)
                        userUpdateDone = true
                        checkIfDone()
                    }
                })
            }
        })
        
        ref.child("posts").child(postID).observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
            if let _ = snapshot.value as? [String: AnyObject] {
                let updateFavorites: [String : Any] = [ "peopleFavourited/\(keyToPost)" : id]
                self?.ref.child("posts").child(postID).updateChildValues(updateFavorites, withCompletionBlock: { (error, ref) in
                    if error == nil {
                        self?.ref.child("posts").child(postID).observeSingleEvent(of: .value, with: { [weak self] (snap) in
                            if let properties = snap.value as? [String : AnyObject] {
                                if let favorites = properties["peopleFavourited"] as? [String : AnyObject] {
                                    let count = favorites.count
                                    self?.count = count
                                    
                                    let update = ["favourites" : count]
                                    self?.ref.child("posts").child(postID).updateChildValues(update)
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
        
        ref.child("posts").child(postID).child("peopleFavourited").child(uid).removeValue(completionBlock: { [weak self] (error, ref) in
            self?.favoritePosts.first(where: { $0.postID == postID})?.peopleFavorited.removeAll(where: { $0 == uid})
            self?.favoritePosts.removeAll(where: { $0.postID == postID})
            if error == nil {
                self?.ref.child("posts").child(postID).observeSingleEvent(of: .value, with: { [weak self] (snap) in
                    if let prop = snap.value as? [String : AnyObject] {
                        if let favorites = prop["peopleFavourited"] as? [String : AnyObject] {
                            let count = favorites.count
                            self?.count = count
                            self?.ref.child("posts").child(postID).updateChildValues(["favourites" : count]) } else {
                            self?.count = 0
                            self?.ref.child("posts").child(postID).updateChildValues(["favourites" : 0])
                            postUpdateDone = true
                            checkIfDone()
                            
                        }
                    }
                })
            }
        })
        //        completionHandler(false)
    }
    
    
    func follow(idx: String, with completionHandler: @escaping (Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let following = ["following/\(idx)" : idx]
        let followers = ["followers/\(uid)" : uid]
        
        ref.child("users").child(uid).updateChildValues(following)
        ref.child("users").child(idx).updateChildValues(followers as [AnyHashable : Any])
        
        completionHandler(true)
    }
    
    func unfollow(idx: String, with completionHandler: @escaping (Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        ref.child("users").child(uid).child("following").queryOrderedByKey().observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
            
            self?.ref.child("users").child(uid).child("following/\(uid)").removeValue()
            self?.ref.child("users").child(idx).child("followers/\(idx)").removeValue()
            completionHandler(true)
            
        })
    }
    
    func checkFollowingStatus(idx: String, with completionHandler: @escaping (Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        DatabaseService.instance.ref.child("users").child(uid).child("following").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
            if let following = snapshot.value as? [String : AnyObject] {
                for (_, value) in following {
                    if value as? String == idx {
                        completionHandler(true)
                    }
                }
            }
        })
    }
    
    func deleteAccount() {
        let currentUser = Auth.auth().currentUser
        guard let uid = currentUser?.uid else { return }
        
        currentUser?.delete(completion: { [weak self] (error) in
            if let error = error {
                print(error)
            } else {
                self?.ref.child("users").child(uid).removeValue()
                
                self?.ref.child("users").observeSingleEvent(of: .value) { (snapshot) in
                    guard let users = snapshot.value as? [String: AnyObject] else { return }
                    for user in users {
                        let key = user.key
                        self?.ref.child("users").child(key).child("followers").observeSingleEvent(of: .value, with: { (snap) in
                            if let followers = snap.value as? [String: AnyObject] {
                                for userID in followers {
                                    if (userID.value as! String) == uid {
                                        self?.ref.child("users").child(key).child("followers/\(uid)").removeValue()
                                    }
                                }
                            }
                        })
                        
                        self?.ref.child("users").child(key).child("following").observeSingleEvent(of: .value, with: { (snap) in
                            if let followings = snap.value as? [String: AnyObject] {
                                for userID in followings {
                                    if (userID.value as! String) == uid {
                                        self?.ref.child("users").child(key).child("following/\(uid)").removeValue()
                                    }
                                }
                            }
                        })
                    }
                }
                self?.ref.child("posts").observeSingleEvent(of: .value) { (snapshot) in
                    guard let posts = snapshot.value as? [String: AnyObject] else { return }
                    for post in posts {
                        let key = post.key
                        self?.ref.child("posts").child(key).child("peopleFavourited").observeSingleEvent(of: .value, with: { (snap) in
                            if let peopleFavorited = snap.value as? [String: AnyObject] {
                                for userID in peopleFavorited {
                                    if (userID.value as! String) == uid {
                                        self?.ref.child("posts").child(key).child("peopleFavourited/\(uid)").removeValue()
                                    }
                                }
                            }
                        })
                    }
                }
            }
        })
    }
    
    func deletePost(postID: String) {
        ref.child("posts").child(postID).removeValue()
        
        ref.child("users").observeSingleEvent(of: .value) { [weak self] (snapshot) in
            guard let users = snapshot.value as? [String: AnyObject] else { return }
            for user in users {
                let key = user.key
                self?.ref.child("users").child(key).child("favouritedPosts").observeSingleEvent(of: .value, with: { (snap) in
                    if let favoritedPost = snap.value as? [String: AnyObject] {
                        for post in favoritedPost {
                            if post.value as! String == postID {
                                self?.ref.child("users").child(key).child("favouritedPosts").child(postID).removeValue()
                            }
                        }
                    }
                })
            }
        }
    }
    
    func getCurrentUID() -> String? {
       return Auth.auth().currentUser?.uid
    }
}
