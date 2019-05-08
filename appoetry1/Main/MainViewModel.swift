//
//  MainViewModel.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 01.03.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

class MainViewModel: NSObject {
    
    var onCreatePostTap: (() -> Void)?
    var onAuthorTap: ((String) -> Void)?
    var onPostTap: ((String) -> Void)?
    var onEditPostTap: ((String) -> Void)?
    var onFavoriteButtonTap: (() -> Void)?

    var reloadAtIndex: ((Int) -> Void)?
    var databaseService: DatabaseService?
    
    init(databaseService: DatabaseService) {
        self.databaseService = databaseService
    }

    func createPost() {
        onCreatePostTap?()
    }
    
    func toggleFavourite(at row: Int) {
        let currentUser = DatabaseService.instance.currentUserID
        let posts = databaseService?.mainPosts
        guard posts?.indices.contains(row) == true else { return }
        guard let post = posts?[row] else { return }
        let isFavourite = post.peopleFavorited.contains(currentUser!) == true
        guard let id = post.postID else { return }
        
        if isFavourite {
            unfavoritePost(postID: id) { [weak self] (_) in
                self?.reloadAtIndex?(row)
            }
        } else {
            favoritePost(postID: id) { [weak self] (_) in
                self?.reloadAtIndex?(row)
            }
            
        }
//        return databaseService?.mainPosts
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
