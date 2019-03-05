//
//  AppFlow.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 25.02.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

class AppFlow: PFlowController {
    
    var window: UIWindow
    
    fileprivate var childFlow: PFlowController?
    
    var rootVC = UIViewController()
    
    init(with window: UIWindow) {
        self.window = window
        guard let mainVC = mainViewController else { return }
        rootVC = mainVC
        window.rootViewController = rootVC
        window.makeKeyAndVisible()
    }
    
    func start() {
        let loginFlow = LoginFlow(with: rootVC)
        loginFlow.start()
        
        loginFlow.onSuccessfullLogin = {[weak self] in
            self?.rootVC.dismiss(animated: false, completion: nil)
            self?.showMainScreen()
            debugPrint("LoginFlow completed with successful login")
        }
        
        loginFlow.onRegistrationTap = {[weak self] in
            self?.rootVC.dismiss(animated: false, completion: nil)
            self?.getToRegistrationScreen()
            debugPrint("LoginFlow completed on register button tap")
        }
        childFlow = loginFlow
    }
    
    private func getToRegistrationScreen() {
        let regFlow = RegFlow(with: rootVC)
        
        regFlow.onBackButtonTap = { [weak self] in
            self?.rootVC.dismiss(animated: false, completion: nil)
            self?.start()
        }
        
        regFlow.onThirdStepNextTap = { [weak self] in
            self?.rootVC.dismiss(animated: false, completion: nil)
            self?.showMainScreen()
        }
        
        regFlow.start()
        childFlow = regFlow
    }
    
    private func showMainScreen() {
        let mainFlow = MainFlow(with: rootVC)
        mainFlow.start()
        childFlow = mainFlow
    }
}

extension AppFlow {
    
    fileprivate var mainSB: UIStoryboard {
        return UIStoryboard(name: Storyboard.main.rawValue, bundle: Bundle.main)
    }
    
    fileprivate var mainViewController: MainViewController? {
        return mainSB.instantiateViewController(withIdentifier: MainViewController.className) as? MainViewController
    }
}
