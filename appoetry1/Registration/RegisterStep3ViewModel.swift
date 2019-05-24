//
//  RegisterStep3ViewModel.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 26.02.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

final class RegisterStep3ViewModel {
    
    var realGenre: Genres?
    var onMainScreen: (() -> Void)?
    
    var databaseService: DatabaseService?
    
    init(databaseService: DatabaseService) {
        self.databaseService = databaseService
    }
    
    func addThirdStepCredentials(firstGenre: String?, secondGenre: String?, thirdGenre: String?) {
        DatabaseService.instance.userInfo.firstGenre = firstGenre
        DatabaseService.instance.userInfo.secondGenre = secondGenre
        DatabaseService.instance.userInfo.thirdGenre = thirdGenre
    }
    
    func toMainScreen() {
        DatabaseService.instance.registerUser { [weak self] (registered) in
            if registered {
                self?.onMainScreen?()
            }
        }
    }
}
