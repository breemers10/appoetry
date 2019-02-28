//
//  RegFlow.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 25.02.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

class RegFlow: PFlowController {
    
    private var registerWindow: UIWindow
    var rootController: UINavigationController?
    var child: PFlowController?
    
    init(with window: UIWindow) {
        self.registerWindow = window
    }
    
    func start() {
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
    
    private var registerStep2ViewController: RegisterStep2ViewController? {
        return regSB.instantiateViewController(withIdentifier: RegisterStep2ViewController.className) as? RegisterStep2ViewController
    }
    
    private var registerStep3ViewController: RegisterStep3ViewController? {
        return regSB.instantiateViewController(withIdentifier: RegisterStep3ViewController.className) as? RegisterStep3ViewController
    }
    
    private var mainViewController: MainViewController? {
        return mainSB.instantiateViewController(withIdentifier: MainViewController.className) as? MainViewController
    }
    
    func start(with completionHandler: @escaping (() -> Void)) {
        guard let vc = registerViewController else { return }
        
        rootController = UINavigationController(rootViewController: vc)
        
        registerWindow.rootViewController = rootController
        registerWindow.makeKeyAndVisible()
        
        let viewModel = RegisterViewModel()
        viewModel.onSecondStep = { [weak self] in
            self?.moveToRegStep2()
        }
        viewModel.onLogin = { [weak self] in
            self?.moveToLogin()
        }
        vc.viewModel = viewModel
    }
    
    func moveToRegStep2() {
        guard let regStep2VC = registerStep2ViewController else { return }
        let vm2 = RegisterStep2ViewModel()
        vm2.onThirdStep = { [weak self] in
            self?.moveToRegStep3()
        }
        regStep2VC.viewModel = vm2
        self.rootController?.pushViewController(regStep2VC, animated: true)
    }
    
    func moveToRegStep3() {
        guard let regStep3VC = registerStep3ViewController else { return }
        let vm3 = RegisterStep3ViewModel()
        vm3.onMainScreen = { [weak self] in
            self?.moveToMain()
        }
        regStep3VC.viewModel = vm3
        self.rootController?.pushViewController(regStep3VC, animated: true)
    }

    func moveToMain() {
        let main = MainFlow(with: registerWindow)
        main.start(with: {
            debugPrint("Flow to main has started")
        })
        child = main
    }
    
    func moveToLogin() {
        let login = LoginFlow(with: registerWindow)
        login.start(with: {
            debugPrint("Flow to main has started")
        })
        child = login
    }
}

