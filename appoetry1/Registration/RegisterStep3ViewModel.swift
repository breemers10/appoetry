//
//  RegisterStep3ViewModel.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 26.02.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class RegisterStep3ViewModel {
    
    var realGenre: Genre?
    var onMainScreen: (() -> Void)?
    var databaseHandle: DatabaseHandle?
    
    func addThirdStepCredentials(firstGenre: String?, secondGenre: String?, thirdGenre: String?) {
        DatabaseService.instance.userRegister.firstGenre = firstGenre
        DatabaseService.instance.userRegister.secondGenre = secondGenre
        DatabaseService.instance.userRegister.thirdGenre = thirdGenre
    }
    
    func toMainScreen() {
        guard
            let email = DatabaseService.instance.userRegister.email,
            let password = DatabaseService.instance.userRegister.password
            else { return }
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if user != nil {
                print("User has signed up")
            }
            guard error == nil else { return }
            guard let id = Auth.auth().currentUser?.uid else { return }
            DatabaseService.instance.ref.child("users").child(id).setValue(DatabaseService.instance.userRegister.sendData())
            
            self.onMainScreen?()
        }
    }
}
