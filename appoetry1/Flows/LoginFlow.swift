//
//  LoginFlow.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 25.02.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

class LoginFlow:  PFlowController {
    fileprivate var childFlow: PFlowController?
    
    var onSuccessfullLogin: (() -> ())?
    var onRegistrationTap: (()->())?
    var onLoginStart: ((UINavigationController) -> Void)?

    private var presenterVC: UINavigationController?
    private var userService: PUserService
    private var databaseService: DatabaseService?
    private var child: PFlowController?
    
    init(userService: PUserService, databaseService: DatabaseService) {
        self.userService = userService
        self.databaseService = databaseService
    }
    
    func start() {
        guard let vc = loginViewController else { return }
        
        let viewModel = LoginViewModel(userService: userService)
        
        viewModel.onCompletion = { [weak self] in
            self?.onSuccessfullLogin?()
        }
        viewModel.onSignUp = { [weak self] in
            self?.getToRegistrationScreen()
        }
        vc.viewModel = viewModel
        presenterVC = UINavigationController(rootViewController: vc)
        guard let loginVC = presenterVC else { return }
        self.onLoginStart?(loginVC)
    }
    
    private func getToRegistrationScreen() {
        guard let regVC = presenterVC else { return }

        let regFlow = RegFlow(navCtrllr: regVC, databaseService: databaseService!)
        
        regFlow.onThirdStepNextTap = { [weak self] in
            self?.onSuccessfullLogin?()
        }
        regFlow.start()
        childFlow = regFlow
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
