//
//  EditPostViewModel.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 08.05.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

final class EditPostViewModel {
    
    var onSuccessfulDeletion: (() -> Void)?
    var onSuccessfulEdit: (() -> Void)?

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
    func editPost(poem: String, postID: String) {
        databaseService?.editPost(poem: poem, postID: postID)
    }
    
    func deletePost(postID: String) {
        databaseService?.deletePost(postID: postID)
    }
}
