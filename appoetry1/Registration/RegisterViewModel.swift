//
//  RegisterViewModel.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 28.02.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

final class RegisterViewModel {
    
    var onFirstStepCompletion: (() -> Void)?
    var onLogin: (() -> Void)?
    private var databaseService: DatabaseService?
    
    init(databaseService: DatabaseService) {
        self.databaseService = databaseService
    }
    
    func addCredentials(email: String, password: String) {
        DatabaseService.instance.userInfo.email = email
        DatabaseService.instance.userInfo.password = password
    }
    
    func secondStep() {
        onFirstStepCompletion?()
    }
    
//    func storeUsersPhoto(data: Data, with completionHandler: @escaping (URL) -> Void) {
//        databaseService?.storeUsersPhoto(data: data, with: { (url) in
//            completionHandler(url)
//        })
//    }
    
    func checkIfEmailIsTaken(emailAddressString: String, with completionHandler: @escaping (Bool) -> Void) {
        databaseService?.isEmailAlreadyTaken(emailAddressString: emailAddressString, with: { (isTaken) in
            if isTaken {
                completionHandler(true)
            } else {
                completionHandler(false)
            }
        })
    }
}

