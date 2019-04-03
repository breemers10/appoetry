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
    
    func openPost() {
        databaseService?.openPost(idx: idx)
    }
    
    func favouritePost(postID: String) {
        databaseService?.favouritePressed(postID: postID)
    }
    
    func unfavouritePost(postID: String) {
        databaseService?.unfavouritePressed(postID: postID)
    }
}
