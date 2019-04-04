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
    
    func get(author: String?, poem: String?, genre: String?, data: Data?) {
        databaseService?.getUsername(with: { [weak self] (username) in
            guard let data = data else { return }
            self?.storePostPhoto(data: data) { (url,key)  in
                let feed = ["userID" : self?.databaseService?.currentUserID as Any,
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
}
