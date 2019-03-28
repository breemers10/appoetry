//
//  RegisterStep2ViewModel.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 28.02.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

class RegisterStep2ViewModel {
    
    var onThirdStep: (() -> Void)?
    var onFirstStep: (() -> Void)?
    
    func addSecondStepCredentials(username: String, fullName: String, dateOfBirth: String?) {
        DatabaseService.instance.userRegister.username = username
        DatabaseService.instance.userRegister.fullName = fullName
        DatabaseService.instance.userRegister.dateOfBirth = dateOfBirth
    }
    
    func toThirdStep() {
        onThirdStep?()
    }
    
    func toFirstStep() {
        onFirstStep?()
    }
}
