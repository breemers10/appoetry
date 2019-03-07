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
        if isValid2(email: email ) {
            let dummyUser = User.init(email: email)
            self.user = dummyUser
            completionHandler(dummyUser, nil)
        } else {
            completionHandler(nil, "")
        }
    }
    
    func isValid2(email: String) -> Bool {
        
        let regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let pred = NSPredicate(format: "SELF MATCHES %@", regEx)
        return pred.evaluate(with: email)
    }
}
