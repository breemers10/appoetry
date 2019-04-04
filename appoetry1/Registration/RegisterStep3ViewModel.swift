//
//  RegisterStep3ViewModel.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 26.02.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class RegisterStep3ViewModel {
    
    var realGenre: Genre?
    var onMainScreen: (() -> Void)?
    var databaseHandle: DatabaseHandle?
    
    var databaseService: DatabaseService?
    
    init(databaseService: DatabaseService) {
        self.databaseService = databaseService
    }
    
    func addThirdStepCredentials(firstGenre: String?, secondGenre: String?, thirdGenre: String?) {
        DatabaseService.instance.userRegister.firstGenre = firstGenre
        DatabaseService.instance.userRegister.secondGenre = secondGenre
        DatabaseService.instance.userRegister.thirdGenre = thirdGenre
    }
    
    func toMainScreen() {
        DatabaseService.instance.registerUser { [weak self] (registered) in
            if registered {
                self?.onMainScreen?()
            }
        }
    }
}
