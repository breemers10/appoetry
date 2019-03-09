//
//  RegisterViewModel.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 28.02.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

class RegisterViewModel {
    
    var onFirstStepCompletion: (() -> Void)?
    var onLogin: (() -> Void)?
    
    func addCredentials(email: String, password: String) {
        MySharedInstance.instance.userRegister.email = email
        MySharedInstance.instance.userRegister.password = password
    }
    
    func secondStep() {
        onFirstStepCompletion?()
    }
}

