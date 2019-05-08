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
    var onDeleteButtonPressed: (() -> Void)?
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
    
    func addChangedCredentials(imageUrl: String?, username: String, fullName: String, email: String, firstGenre: String, secondGenre: String, thirdGenre: String, dateOfBirth: String) {
        DatabaseService.instance.userInfo.imageUrl = imageUrl
        DatabaseService.instance.userInfo.username = username
        DatabaseService.instance.userInfo.fullName = fullName
        DatabaseService.instance.userInfo.email = email
        DatabaseService.instance.userInfo.firstGenre = firstGenre
        DatabaseService.instance.userInfo.secondGenre = secondGenre
        DatabaseService.instance.userInfo.thirdGenre = thirdGenre
        DatabaseService.instance.userInfo.dateOfBirth = dateOfBirth
    }
    
    func getUserInfo(with completionHandler: @escaping (Bool) -> Void) {
        databaseService?.getMyProfileInfo(with: { (loaded) in
            if loaded {
                completionHandler(true)
            }
        })
    }
    
    func editCredentials() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        DatabaseService.instance.ref.child("users").child(uid).setValue(DatabaseService.instance.userInfo.sendData())
    }
}
