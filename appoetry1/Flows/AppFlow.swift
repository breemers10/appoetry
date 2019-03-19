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
    var userService: PUserService
    
    init(with window: UIWindow) {
        self.window = window
        userService = UserService()
    }
    
    func start() {
        let loginFlow = LoginFlow(userService: userService)
        
        loginFlow.onLoginStart = {[unowned self] rootController in
            self.window.rootViewController = rootController
            self.window.makeKeyAndVisible()
        }
        
        loginFlow.onSuccessfullLogin = {[weak self] in
            self?.showMainScreen()
            debugPrint("LoginFlow completed with successful login")
        }
        loginFlow.start()
        childFlow = loginFlow
    }
    
    private func showMainScreen() {
        let mainFlow = MainFlow(userService: userService)
        mainFlow.onMainStart = { [weak self] rootController in
            self?.window.rootViewController = rootController
        }
        
        mainFlow.onSignOutCompletion = { [weak self] in
            self?.start()
        }
        
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
