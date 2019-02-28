//
//  LoginViewModel.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 27.02.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

class LoginViewModel {
    
    var onCompletion: (() -> Void)?
    var onSignUp: (() -> Void)?

    func signUp() {
        onSignUp?()
    }
    
    func signIn() {
        onCompletion?()
    }
}
