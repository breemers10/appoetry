//
//  EditProfileViewModel.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 22.03.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit
import Firebase

class EditProfileViewModel: NSObject {
    
    var onEditProfileCompletion: (() -> Void)?
    var realGenre: Genre?
    
    var username: String?
    var email: String?
    var fullName: String?
    var firstGenre: String?
    var secondGenre: String?
    var thirdGenre: String?
    var imageUrl: String?
    
    var databaseService: DatabaseService?
    
    init(databaseService: DatabaseService) {
        self.databaseService = databaseService
    }
    
    func addChangedCredentials(imageUrl: String, username: String, fullName: String, email: String, firstGenre: String, secondGenre: String, thirdGenre: String) {
        DatabaseService.instance.userRegister.imageUrl = imageUrl
        DatabaseService.instance.userRegister.username = username
        DatabaseService.instance.userRegister.fullName = fullName
        DatabaseService.instance.userRegister.email = email
        DatabaseService.instance.userRegister.firstGenre = firstGenre
        DatabaseService.instance.userRegister.secondGenre = secondGenre
        DatabaseService.instance.userRegister.thirdGenre = thirdGenre
    }
    
    func getUserInfo() {
        databaseService?.getMyProfileInfo()
    }
    
    func editCredentials() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        DatabaseService.instance.ref.child("users").child(uid).setValue(DatabaseService.instance.userRegister.sendData())
    }
}
