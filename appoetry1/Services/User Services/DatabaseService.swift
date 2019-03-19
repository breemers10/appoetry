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
}
