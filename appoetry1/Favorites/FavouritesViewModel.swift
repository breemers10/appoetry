//
//  FavouritesViewModel.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 08.03.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

class FavouritesViewModel: NSObject {
    
    var onCreatePostTap: (() -> Void)?
    var onAuthorTap: ((String) -> Void)?
    
    var databaseService: DatabaseService?
    
    init(databaseService: DatabaseService) {
        self.databaseService = databaseService
    }
    
    func createPost() {
        onCreatePostTap?()
    }
    
    func getFavouritesPosts(with completionHandler: @escaping (Bool) -> Void) {
        databaseService?.loadFavouriteFeed(with: { (loaded) in
            if loaded {
                completionHandler(true)
            }
        })
    }
    
    func favouritePost(postID: String, with completionHandler: @escaping (Bool) -> Void) {
        databaseService?.favouritePressed(postID: postID, with: { (favorited) in
            if favorited {
                completionHandler(true)
            }
        })
    }
    
    func unfavouritePost(postID: String, with completionHandler: @escaping (Bool) -> Void) {
        databaseService?.unfavouritePressed(postID: postID, with: { (unfavorited) in
            if unfavorited {
                completionHandler(true)
            }
        })
    }
}
