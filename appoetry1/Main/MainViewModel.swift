//
//  MainViewModel.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 01.03.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit
import Firebase

class MainViewModel: NSObject {
    
    var onCreatePostTap: (() -> Void)?
    var onAuthorTap: ((String) -> Void)?
    var onPostTap: ((String) -> Void)?
    var onFavoriteButtonTap: (() -> Void)?

    var databaseService: DatabaseService?
    
    init(databaseService: DatabaseService) {
        self.databaseService = databaseService
    }

    func createPost() {
        onCreatePostTap?()
    }
    
    func getMainFeed(with completionHandler: @escaping (Bool) -> Void) {
        databaseService?.loadMainFeed(with: { (loaded) in
            if loaded {
                completionHandler(true)
            }
        })
    }
    
    func checkIfChanged(with completionHandler: @escaping (Bool) -> Void) {
        databaseService?.postChildChanged(with: { (isChanged) in
            if isChanged {
                completionHandler(true)
            }
        })
    }
    
    func favoritePost(postID: String, with completionHandler: @escaping (Bool) -> Void) {
        databaseService?.favoritePressed(postID: postID, with: { (favorited) in
            if favorited {
                completionHandler(true)
            }
        })
    }
    
    func unfavoritePost(postID: String, with completionHandler: @escaping (Bool) -> Void) {
        databaseService?.unfavoritePressed(postID: postID, with: { (unfavorited) in
            if unfavorited {
                completionHandler(true)
            }
        })
    }
}
