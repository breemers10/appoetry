//
//  RegisterStep2ViewModel.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 28.02.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

final class RegisterStep2ViewModel {
    
    var onThirdStep: (() -> Void)?
    var onFirstStep: (() -> Void)?
    private var databaseService: DatabaseService?
    
    init(databaseService: DatabaseService) {
        self.databaseService = databaseService
    }
    
    func addSecondStepCredentials(username: String, fullName: String, dateOfBirth: String?) {
        DatabaseService.instance.userInfo.username = username
        DatabaseService.instance.userInfo.fullName = fullName
        DatabaseService.instance.userInfo.dateOfBirth = dateOfBirth
    }
    
    func checkIfUsernameIsUsed(username: String, with completionHandler: @escaping (Bool) -> Void) {
        databaseService?.isUsernameAlreadyTaken(username: username, with: { (isTaken) in
            if isTaken {
                completionHandler(true)
            } else {
                completionHandler(false)
            }
        })
    }
    
    func toThirdStep() {
        onThirdStep?()
    }
    
    func toFirstStep() {
        onFirstStep?()
    }
}
