//
//  DatabaseService.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 19.03.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit
import Firebase

class DatabaseService {
    var username: String?
    var following = [String]()
    var usersPosts = [String]()
    var posts = [Post]()
    var favouritedPosts = [String]()
    
    func creatingPosts(data: Data, poemText: String, genreText: String) {
        AppDelegate.instance().showActivityIndicator()
        
        let uid = Auth.auth().currentUser!.uid
        MySharedInstance.instance.ref.child("users").child(uid).observe(.childAdded, with: { (snapshot) in
            if snapshot.key == "username" {
                self.username = snapshot.value as? String
            }
        })
        
        let key = MySharedInstance.instance.ref.child("posts").childByAutoId().key
        let storage = Storage.storage().reference(forURL : "gs://appoetry1.appspot.com")
        
        let imageRef = storage.child("posts").child(uid).child("\(String(describing: key)).jpg")
        
        
        let uploadTask = imageRef.putData(data, metadata: nil) { (metadata, error) in
            if error != nil {
                print(error!.localizedDescription)
                AppDelegate.instance().dismissActivityIndicator()
                return
            }
            
            imageRef.downloadURL(completion: { (url, error) in
                if let url = url {
                    let feed = ["userID" : uid,
                                "poem" : poemText,
                                "pathToImage" : url.absoluteString,
                                "favourites" : 0,
                                "author" : self.username!,
                                "genre" : genreText,
                                "postID" : key! ] as [String : Any]
                    let postFeed = ["\(key!)" : feed]
                    
                    MySharedInstance.instance.ref.child("posts").updateChildValues(postFeed)
                    
                    AppDelegate.instance().dismissActivityIndicator()
                }
            })
        }
        uploadTask.resume()
    }
    
    func fetchFollowingPosts() {
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
        
        MySharedInstance.instance.ref.child("posts").observeSingleEvent(of: .value, with: { (snap) in
            let postSnap = snap.value as! [String: AnyObject]
            
            for (_,post) in postSnap {
                if let userID = post["userID"] as? String {
                    for each in self.following {
                        if each == userID {
                            let posst = Post()
                            if let author = post["author"] as? String, let favourites = post["favourites"] as? Int, let pathToImage = post["pathToImage"] as? String, let postID = post["postID"] as? String, let poem = post["poem"] as? String, let genre = post["genre"] as? String {
                                posst.username = author
                                posst.favourites = favourites
                                posst.pathToImage = pathToImage
                                posst.postID = postID
                                posst.userID = userID
                                posst.poem = poem
                                posst.genre = genre
                                
                                if let people = post["peopleFavourited"] as? [String : AnyObject] {
                                    for (_,person) in people {
                                        posst.peopleFavourited.append(person as! String)
                                    }
                                }
                                self.posts.append(posst)
                            }
                        }
                        AppDelegate.instance().dismissActivityIndicator()
                    }
                }
            }
        })
        MySharedInstance.instance.ref.removeAllObservers()
    }
    
    func fetchProfilePosts() {
        
        AppDelegate.instance().showActivityIndicator()
        
        let uid = Auth.auth().currentUser?.uid
        
        MySharedInstance.instance.ref.child("users").child(uid!).queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            _ = snapshot.value as! [String : AnyObject]
            
            self.usersPosts.append(Auth.auth().currentUser!.uid)
            AppDelegate.instance().dismissActivityIndicator()
        })
        
        MySharedInstance.instance.ref.child("posts").observeSingleEvent(of: .value, with: { (snap) in
            let postSnap = snap.value as! [String: AnyObject]
            
            for (_,post) in postSnap {
                if let userID = post["userID"] as? String {
                    for each in self.usersPosts {
                        if each == userID {
                            let posst = Post()
                            if let author = post["author"] as? String, let favourites = post["favourites"] as? Int, let pathToImage = post["pathToImage"] as? String, let postID = post["postID"] as? String, let poem = post["poem"] as? String, let genre = post["genre"] as? String {
                                posst.username = author
                                posst.favourites = favourites
                                posst.pathToImage = pathToImage
                                posst.postID = postID
                                posst.userID = userID
                                posst.poem = poem
                                posst.genre = genre
                                
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
    
    func fetchFavouritePosts() {
        AppDelegate.instance().showActivityIndicator()
        
        let uid = Auth.auth().currentUser?.uid
        
        MySharedInstance.instance.ref.child("users").child(uid!).queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            let snap = snapshot.value as! [String : AnyObject]

            if let favouritedPosts = snap["favouritedPosts"] as? [String : String] {
                for (_,post) in favouritedPosts {
                    self.following.append(post)
                }
            }
            
            self.following.append(uid!)
            
//
//            let favouritePosts2 = snap["favouritePosts"] as! String
//
//            self.favouritedPosts.append(favouritePosts2)
            AppDelegate.instance().dismissActivityIndicator()
        })
        
        MySharedInstance.instance.ref.child("posts").observeSingleEvent(of: .value, with: { (snap) in
            let postSnap = snap.value as! [String: AnyObject]
            
            for (_,post) in postSnap {
                if let userID = post["userID"] as? String {
                    for each in self.favouritedPosts {
                        if each == userID {
                            let posst = Post()
                            if let author = post["author"] as? String, let favourites = post["favourites"] as? Int, let pathToImage = post["pathToImage"] as? String, let postID = post["postID"] as? String, let poem = post["poem"] as? String, let genre = post["genre"] as? String {
                                posst.username = author
                                posst.favourites = favourites
                                posst.pathToImage = pathToImage
                                posst.postID = postID
                                posst.userID = userID
                                posst.poem = poem
                                posst.genre = genre
                                
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
