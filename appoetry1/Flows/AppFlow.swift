//
//  AppFlow.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 25.02.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

protocol FlowController: class {
    var window: UIWindow?? { get }
    func start()
}

extension FlowController {
    var window: UIWindow?? {
        return UIApplication.shared.delegate!.window
    }
}

class AppFlow: FlowController {
    fileprivate var childFlow: FlowController?
    init() {
        goToLogin()
        goToMain()
        goToReg()
        goToRegStep2()
    }
    
    func start() {
        let loginFlow = LoginFlow()
        window??.rootViewController = loginFlow.rootController
        
        loginFlow.start()
        childFlow = loginFlow
    }
    
    private func goToMain() {
        NotificationCenter.default.addObserver(self, selector: #selector(moveToMain), name: Notification.Name("goToMain"), object: nil)
    }
    
    private func goToLogin() {
        NotificationCenter.default.addObserver(self, selector: #selector(moveToLogin), name: Notification.Name("goToLogin"), object: nil)
    }
    
    @objc func moveToLogin() {
                start()
    }
    
    @objc func moveToMain() {
        let mainFlow = MainFlow()
        window??.rootViewController = mainFlow.rootController
        
        mainFlow.start()
        childFlow = mainFlow
    }
    
    private func goToReg() {
        NotificationCenter.default.addObserver(self, selector: #selector(moveToReg), name: Notification.Name("goToReg"), object: nil)
    }
    
    @objc func moveToReg() {
        let regFlow = RegFlow()
        window??.rootViewController = regFlow.rootController
        
        regFlow.start()
        childFlow = regFlow
}
    private func goToRegStep2() {
        NotificationCenter.default.addObserver(self, selector: #selector(moveToRegStep2), name: Notification.Name("goToRegStep2"), object: nil)
    }
    
    @objc func moveToRegStep2() {
        let regFlow = RegFlow()
        window??.rootViewController = regFlow.rootController
        
        regFlow.secondStep()
        childFlow = regFlow
    }
}
