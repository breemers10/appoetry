//
//  RegisterViewModel.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 28.02.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

class RegisterViewModel {
    
    var onSecondStep: (() -> Void)?
    var onLogin: (() -> Void)?
    
    func secondStep() {
        onSecondStep?()
    }
    
    func backToSignIn() {
        onLogin?()
    }
}

