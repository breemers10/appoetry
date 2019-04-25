//
//  SearchViewModel.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 08.03.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit
import Firebase

class SearchViewModel: NSObject {
    var onCreatePostTap: (() -> Void)?
    var onCellTap: ((String) -> Void)?

    var databaseService: DatabaseService?
    
    init(databaseService: DatabaseService) {
        self.databaseService = databaseService
    }
    
    func createPost() {
        onCreatePostTap?()
    }
    
    func fetchUsers(with completionHandler: @escaping (Bool) -> Void) {
        databaseService?.searchUsers(with: { (loaded) in
            if loaded {
                completionHandler(true)
            }
        })
    }
}
