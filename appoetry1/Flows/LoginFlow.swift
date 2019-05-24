//
//  LoginFlow.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 25.02.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

final class LoginFlow:  PFlowController {
    fileprivate var childFlow: PFlowController?
    
    var onSuccessfullLogin: (() -> ())?
    var onRegistrationTap: (()->())?
    var onLoginStart: ((UINavigationController) -> Void)?

    private var presenterVC: UINavigationController?
    private var databaseService: PDatabaseService?
    private var child: PFlowController?
    
    private var loginSB = UIStoryboard.getStoryboard(with: StoryboardNames.login)
    
    init(databaseService: PDatabaseService) {
        self.databaseService = databaseService as! DatabaseService
    }
    
    func start() {
        guard let vc = loginViewController else { return }
        
        let viewModel = LoginViewModel(databaseService: databaseService!)
        
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

        let regFlow = RegFlow(navCtrllr: regVC, databaseService: databaseService as! DatabaseService)
        
        regFlow.onThirdStepNextTap = { [weak self] in
            self?.onSuccessfullLogin?()
        }
        regFlow.start()
        childFlow = regFlow
    }
}

extension LoginFlow {
    fileprivate var loginViewController: LoginViewController? {
        return loginSB.instantiateViewController(withIdentifier: String.className(LoginViewController.self)) as? LoginViewController
    }
}
