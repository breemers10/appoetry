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
        MySharedInstance.instance.userRegister.username = username
        MySharedInstance.instance.userRegister.fullName = fullName
        MySharedInstance.instance.userRegister.dateOfBirth = dateOfBirth
    }
    
    func toThirdStep() {
        onThirdStep?()
    }
    
    func toFirstStep() {
        onFirstStep?()
    }
}
