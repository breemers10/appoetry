//
//  RegFlow.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 25.02.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

class RegFlow: FlowController {
    
    let rootController = UINavigationController()
    
    private lazy var loginSB: UIStoryboard = {
        return UIStoryboard(name: "Login", bundle: Bundle.main)
    }()
    
    private var registerViewController1: RegisterViewController? {
        return loginSB.instantiateViewController(withIdentifier: "Register1VC") as? RegisterViewController
    }
    private var registerStep2ViewController: RegisterStep2ViewController? {
        return loginSB.instantiateViewController(withIdentifier: "Register2VC") as? RegisterStep2ViewController
    }
    private var registerStep3ViewController: RegisterStep3ViewController? {
        return loginSB.instantiateViewController(withIdentifier: "Register3VC") as? RegisterStep3ViewController
    }
    
    func start() {
        guard let vc = registerViewController1 else {
            fatalError("Could not get register vc")
        }
        self.rootController.pushViewController(vc, animated: true)
    }
    
    func secondStep() {
        guard let vc2 = registerStep2ViewController else {
            fatalError("Could not get register vc")
        }  
        self.rootController.pushViewController(vc2, animated: true)
    }

func thirdStep() {
    guard let vc3 = registerStep3ViewController else {
        fatalError("Could not get register vc")
    }
    self.rootController.pushViewController(vc3, animated: true)
}
}

