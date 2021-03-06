//
//  FollowingViewModel.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 21.03.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

final class FollowingViewModel {
    var onCreatePostTap: (() -> Void)?
    var onCellTap: ((String) -> Void)?
    
    var followingArray: [String] = []
    var idx: String
    
    var databaseService: DatabaseService?
    
    init(idx: String, databaseService: DatabaseService) {
        self.databaseService = databaseService
        self.idx = idx
    }
    
    func fetchFollowings(with completionHandler: @escaping (Bool) -> Void) {
        databaseService?.getFollowings(idx: idx, with: { (loaded) in
            if loaded {
                completionHandler(true)
            }
        })
    }
}
