//
//  DumbUserService.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 06.03.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

class DumbUserService: PUserService {
    var user: User?
    
    func loginWithEmailAndPassword(with email: String, with password: String, with completionHandler: @escaping ((User?, String?) -> Void)) {
        let dummyUser = User.init(email: "dummyEmail@email.com")
        self.user = dummyUser
        completionHandler(dummyUser, nil)
    }
}
