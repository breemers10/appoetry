//
//  AppFlow.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 25.02.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

protocol FlowController: class {
    func start()
}

extension FlowController {
    var window: UIWindow {
        return (UIApplication.shared.delegate!.window ?? UIWindow()) ?? UIWindow()
    }
}

class AppFlow: FlowController {
    var window: UIWindow
    fileprivate var childFlow: FlowController?
    init(with window: UIWindow) {
        self.window = window
    }
    
    func start() {
    
        let loginFlow = LoginFlow(with: window)
        loginFlow.start(with: {
            debugPrint("Hey I am AppFLow and looks like Login button was preseed!")
            self.moveToMain()
        })
        childFlow = loginFlow
    }

    func moveToLogin() {
        start()
    }
    
    func moveToMain() {
        let mainFlow = MainFlow()
        window.rootViewController = mainFlow.rootController
        window.makeKeyAndVisible()
        mainFlow.start()
        childFlow = mainFlow
    }
    
    let regFlow = RegFlow()
    
    func moveToReg() {
        window.rootViewController = regFlow.rootController
        regFlow.start()
        childFlow = regFlow
    }

    func moveToRegStep2() {
        window.rootViewController = regFlow.rootController
        regFlow.secondStep()
    }
    
    func moveToRegStep3() {
        window.rootViewController = regFlow.rootController
        regFlow.thirdStep()
    }
}
