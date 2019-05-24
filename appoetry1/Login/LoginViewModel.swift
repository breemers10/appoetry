//
//  LoginViewModel.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 27.02.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

final class LoginViewModel {
    
    var onCompletion: (() -> Void)?
    var onSignUp: (() -> Void)?
    var wrongCredentials: (()->Void)?
    var databaseService: PDatabaseService?
    var error: String?
    
    func signUp() {
        onSignUp?()
    }
    
    init(databaseService: PDatabaseService) {
        self.databaseService = databaseService
    }
    
    func signIn(email: String?, password: String?) {
        self.error = "Not good homie"
        guard email?.isEmpty != true, password?.isEmpty != true else { return }
        databaseService?.loginWithEmailAndPassword(with: email!, with: password!, with: { [weak self] user, error  in
            if error != nil {
                self?.wrongCredentials?()
            } else {
                self?.onCompletion?()
                self?.error = "All gucci senjor"
            }
        })
    }
}
