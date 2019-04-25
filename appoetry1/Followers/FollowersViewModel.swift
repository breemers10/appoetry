//
//  FollowersViewModel.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 21.03.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

class FollowersViewModel {
    var onCreatePostTap: (() -> Void)?
    var onCellTap: ((String) -> Void)?
    
    var followersArray: [String] = []
    var idx: String
    
    var databaseService: DatabaseService?
    
    init(idx: String, databaseService: DatabaseService) {
        self.databaseService = databaseService
        self.idx = idx
    }
    
    func fetchFollowers(with completionHandler: @escaping (Bool) -> Void) {
        databaseService?.getFollowers(idx: idx, with: { (loaded) in
            if loaded {
                completionHandler(true)
            }
        })
    }
}
