//
//  LoginFlow.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 25.02.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

class LoginFlow:  PFlowController {
    
    private var loginWindow: UIWindow
    var rootController: UINavigationController?
    var child: PFlowController?
    
    init(with window: UIWindow) {
        self.loginWindow = window
    }
    
    func start() {
        debugPrint("Start")
    }
    
    private lazy var loginSB: UIStoryboard = {
        return UIStoryboard(name: Storyboard.login.rawValue, bundle: Bundle.main)
    }()
    
    private lazy var regSB: UIStoryboard = {
        return UIStoryboard(name: Storyboard.register.rawValue, bundle: Bundle.main)
    }()
    
    private lazy var mainSB: UIStoryboard = {
        return UIStoryboard(name: Storyboard.main.rawValue, bundle: Bundle.main)
    }()
    
    private var loginViewController: LoginViewController? {
        return loginSB.instantiateViewController(withIdentifier: LoginViewController.className) as? LoginViewController
    }
    
    private var registerViewController: RegisterViewController? {
        return regSB.instantiateViewController(withIdentifier: RegisterViewController.className) as? RegisterViewController
    }
    private var mainViewController: MainViewController? {
        return mainSB.instantiateViewController(withIdentifier: MainViewController.className) as? MainViewController
    }
    
    func start(with completionHandler: @escaping (() -> Void)) {
        guard let vc = loginViewController else { return }
        rootController = UINavigationController(rootViewController: vc)
        loginWindow.rootViewController = rootController
        loginWindow.makeKeyAndVisible()
        let viewModel = LoginViewModel()
        viewModel.onCompletion = { [weak self] in
            self?.moveToMain()
        }
        viewModel.onSignUp = { [weak self] in
            self?.moveToReg()
        }
        vc.viewModel = viewModel
    }
    
    func moveToReg() {
        let reg = RegFlow(with: loginWindow)
        reg.start (with: {
            debugPrint("Registration first step")
        })
        child = reg
    }
    
    func moveToMain() {
        let main = MainFlow(with: loginWindow)
        main.start(with: {
            debugPrint("Flow to main has started")
        })
        child = main
    }
}
