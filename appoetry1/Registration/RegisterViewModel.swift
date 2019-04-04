//
//  RegisterViewModel.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 28.02.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewModel {
    
    var onFirstStepCompletion: (() -> Void)?
    var onLogin: (() -> Void)?
    var databaseService: DatabaseService?
    
    init(databaseService: DatabaseService) {
        self.databaseService = databaseService
    }
    
    func addCredentials(email: String, password: String, imageUrl: String) {
        DatabaseService.instance.userRegister.email = email
        DatabaseService.instance.userRegister.password = password
        DatabaseService.instance.userRegister.imageUrl = imageUrl
    }
    
    func secondStep() {
        onFirstStepCompletion?()
    }
    
    func storeUsersPhoto(data: Data, with completionHandler: @escaping (URL) -> Void) {
        databaseService?.storeUsersPhoto(data: data, with: { (url) in
            completionHandler(url)
        })
    }
}

