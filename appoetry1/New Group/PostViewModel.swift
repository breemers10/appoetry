//
//  PostViewModel.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 01.04.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

class PostViewModel: NSObject {
    var onAuthorTap: ((String) -> Void)?
    
    var idx: String
    var databaseService: DatabaseService?
    
    init(idx: String, databaseService: DatabaseService) {
        self.databaseService = databaseService
        self.idx = idx
    }
    
    func openPost(with completionHandler: @escaping (Bool) -> Void) {
        databaseService?.openPost(idx: idx, with: { (loaded) in
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
