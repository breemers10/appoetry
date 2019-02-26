//
//  LoginFlow.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 25.02.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

class LoginFlow:  FlowController {
    func start() {
        guard let vc = loginViewController else {
            fatalError("Could not get login vc")
        }
        self.rootController.pushViewController(vc, animated: true)
    }
    
    let rootController = UINavigationController()
    
    private lazy var mainSB: UIStoryboard = {
        return UIStoryboard(name: "Login", bundle: Bundle.main)
    }()
    
    private var loginViewController: LoginViewController? {
        return mainSB.instantiateViewController(withIdentifier: "LoginVC") as? LoginViewController
    }
}
