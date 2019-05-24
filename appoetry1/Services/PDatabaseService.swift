//
//  PDatabaseService.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 01.03.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import Foundation

protocol PDatabaseService {
    var loginEmail: LoginEmail? { get }
    var isLoggedIn: Bool { get }

    func loginWithEmailAndPassword(with email: String, with password: String, with completionHandler: @escaping ((LoginEmail?, String?) -> Void))
}
