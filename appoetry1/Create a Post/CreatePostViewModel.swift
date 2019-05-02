//
//  CreatePostViewModel.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 14.03.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

class CreatePostViewModel {
    var realGenre: Genre?
    var onMainScreen: (() -> Void)?
    var databaseService: DatabaseService?
    
    init(databaseService: DatabaseService) {
        self.databaseService = databaseService
    }
    
    func toMainScreen() {
        self.onMainScreen?()
    }
    func storePostPhoto(data: Data, with completionHandler: @escaping (URL, String) -> Void) {
        databaseService?.storePostPhoto(data: data, with: { (url, key) in
            completionHandler(url, key)
        })
    }
    func storePost(author: String?, poem: String?, genre: String?, data: Data?) {
        databaseService?.createPost(author: author, poem: poem, genre: genre, data: data)
    }
}
