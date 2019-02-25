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
    
    private var registerViewController: RegisterViewController? {
        return loginSB.instantiateViewController(withIdentifier: "Register1VC") as? RegisterViewController
    }
    
    func start() {
        guard let vc = registerViewController else {
            fatalError("Could not get register vc")
        }
        
        vc.showMeAgain = { [weak self] in
            self?.pushAgain()
        }
        
        self.rootController.setViewControllers([vc], animated: false)
    }
    func pushAgain() {
        
        guard let vc = registerViewController else {
            fatalError("Could not push to login vc")
        }
        
        vc.showMeAgain = { [weak self] in
            self?.pushAgain()
        }
        self.rootController.pushViewController(vc, animated: true)
    }
    
}
