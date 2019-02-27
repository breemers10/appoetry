//
//  LoginFlow.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 25.02.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

class LoginFlow:  FlowController {
    var onCompletion: (() -> Void)?
    private var loginWindow: UIWindow
    
    init(with window: UIWindow) {
        self.loginWindow = window
    }
    
    func start() {
    }
    
    private lazy var mainSB: UIStoryboard = {
        return UIStoryboard(name: "Login", bundle: Bundle.main)
    }()
    
    private var loginViewController: LoginViewController? {
        return mainSB.instantiateViewController(withIdentifier: "LoginVC") as? LoginViewController
    }
    func start(with completionHandler: @escaping (() -> Void)) {
        guard let vc = loginViewController else { return }
        let rootController = UINavigationController(rootViewController: vc)
        loginWindow.rootViewController = rootController
        loginWindow.makeKeyAndVisible()
        let viewModel = LoginViewModel()
        viewModel.onCompletion = { [weak self] in
            self?.onCompletion?()
        }
        vc.viewModel = viewModel
    }
}
