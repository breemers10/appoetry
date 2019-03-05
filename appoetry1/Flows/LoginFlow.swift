//
//  LoginFlow.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 25.02.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

class LoginFlow:  PFlowController {
    
    var onSuccessfullLogin: (()->())?
    var onRegistrationTap: (()->())?
    
    private var presenterVC: UIViewController
    
    private var child: PFlowController?
    
    init(with controller: UIViewController) {
        presenterVC = controller
    }
    
    func start() {
        guard let vc = loginViewController else { return }
        
        let viewModel = LoginViewModel()
        viewModel.onCompletion = { [weak self] in
            self?.onSuccessfullLogin?()
        }
        viewModel.onSignUp = { [weak self] in
            self?.onRegistrationTap?()
        }
        vc.viewModel = viewModel
        presenterVC.present(vc, animated: false, completion: nil)
    }
}

extension LoginFlow {
    fileprivate var loginSB: UIStoryboard {
        return UIStoryboard(name: Storyboard.login.rawValue, bundle: Bundle.main)
    }
    
    fileprivate var loginViewController: LoginViewController? {
        return loginSB.instantiateViewController(withIdentifier: LoginViewController.className) as? LoginViewController
    }
}
