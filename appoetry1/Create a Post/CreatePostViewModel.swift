//
//  CreatePostViewModel.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 14.03.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit


class CreatePostViewModel {
    var databaseService: DatabaseService
    
    init(databaseService: DatabaseService) {
        self.databaseService = databaseService
    }
     var realGenre: Genre?
    var onMainScreen: (() -> Void)?
    
    func toMainScreen() {
        self.onMainScreen?()
    }
}
