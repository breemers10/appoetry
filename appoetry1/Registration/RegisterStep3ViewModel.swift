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

//enum Genres: Int {
//    case none = 0
//    case birthday = 1
//    case christmas = 2
//    case comedy = 3
//    case erotic = 4
//    case life = 5
//    case love = 6
//    case nature = 7
//    case nonSense = 8
//    case spring = 9
//    case summer = 10
//    case winter = 11
//
//    static var count: Int { return Genres.winter.rawValue + 1 }
//
//    var selectedGenre: String {
//        switch self {
//        case .none: return "-"
//        case .birthday: return "Birthday"
//        case .christmas: return "Christmas"
//        case .comedy: return "Comedy"
//        case .erotic: return "Erotic"
//        case .life: return "Life"
//        case .love: return "Love"
//        case .nature: return "Nature"
//        case .nonSense: return "Non-sense"
//        case .spring: return "Spring"
//        case .summer: return"Summer"
//        case .winter: return "Winter"
//        }
//    }
//}

class RegisterStep3ViewModel {
    
    var realGenre: Genre?
    var onMainScreen: (() -> Void)?
    var databaseHandle: DatabaseHandle?
    
    func addThirdStepCredentials(firstGenre: String?, secondGenre: String?, thirdGenre: String?) {
        MySharedInstance.instance.userRegister.firstGenre = firstGenre
        MySharedInstance.instance.userRegister.secondGenre = secondGenre
        MySharedInstance.instance.userRegister.thirdGenre = thirdGenre
    }
    
    func toMainScreen() {
        guard
            let email = MySharedInstance.instance.userRegister.email,
            let password = MySharedInstance.instance.userRegister.password
            else { return }
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if user != nil {
                print("User has signed up")
            }
            guard error == nil else { return }
            guard let id = Auth.auth().currentUser?.uid else { return }
            MySharedInstance.instance.ref.child("users").child(id).setValue(MySharedInstance.instance.userRegister.sendData())
            
            self.onMainScreen?()
        }
    }
}
