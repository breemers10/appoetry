//
//  LoginViewModel.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 27.02.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit
import Firebase

class LoginViewModel {
    
    var onCompletion: (() -> Void)?
    var onSignUp: (() -> Void)?
    var wrongCredentials: (()->Void)?
    var userService: DumbUserService?
    var error: String?
    
    func signUp() {
        onSignUp?()
    }
    
    init(userService: DumbUserService) {
        self.userService = userService
    }
    
    func signIn(email: String?, password: String?) {
        self.error = "Not good homie"
        guard email?.isEmpty != true, password?.isEmpty != true else { return }
        userService?.loginWithEmailAndPassword(with: email!, with: password!, with: { user, error  in
            if error != nil {
                self.wrongCredentials?()
            } else {
                self.onCompletion?()
                self.error = "All gucci senjor"
            }
            print("Received: \(String(describing: self.userService?.user?.email)))")
        })
    }
}