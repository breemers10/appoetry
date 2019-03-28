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
    
    func fetchUsers() {
        databaseService?.searchUsers()
    }
}
