//
//  AppFlow.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 25.02.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

final class AppFlow: PFlowController {
    
    var window: UIWindow
    
    fileprivate var childFlow: PFlowController?
    var databaseService: PDatabaseService
    
    private var mainSB = UIStoryboard.getStoryboard(with: StoryboardNames.main)
    
    init(with window: UIWindow) {
        self.window = window
        databaseService = DatabaseService()
    }
    
    func start() {
        databaseService.isLoggedIn ? showMainScreen(useTransition: false) : showLoginScreen(useTransition: false)
        
    }
    
    private func showMainScreen(useTransition: Bool) {
        let mainFlow = MainFlow(databaseService: databaseService)
        mainFlow.onMainStart = { [weak self] rootController in
            self?.window.rootViewController = rootController
            self?.window.makeKeyAndVisible()

        }
        
        mainFlow.onSignOutCompletion = { [weak self] in
            self?.showLoginScreen(useTransition: false)
        }
        
        mainFlow.onSuccessfulDeletion = { [weak self] in
            self?.showLoginScreen(useTransition: false)
        }
        
        mainFlow.start()
        childFlow = mainFlow
    }
    
    private func showLoginScreen(useTransition: Bool) {
        let loginFlow = LoginFlow(databaseService: databaseService)

        loginFlow.onLoginStart = {[weak self] rootController in
            self?.window.rootViewController = rootController
            self?.window.makeKeyAndVisible()
        }
        
        loginFlow.onSuccessfullLogin = {[weak self] in
            self?.showMainScreen(useTransition: false)
            debugPrint("LoginFlow completed with successful login")
        }
        loginFlow.start()
        childFlow = loginFlow
    }
}

extension AppFlow {
    fileprivate var mainViewController: MainViewController? {
        return mainSB.instantiateViewController(withIdentifier: String.className(MainViewController.self)) as? MainViewController
    }
}
