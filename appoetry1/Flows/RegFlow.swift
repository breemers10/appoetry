//
//  RegFlow.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 25.02.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

class RegFlow: PFlowController {
    
    var onFirstStepNextTap: (()->())?
    var onSecondStepNextTap: (()->())?
    var onThirdStepNextTap: (()->())?
    var onBackButtonTap: (()->())?
    
    private var navigationController: UINavigationController
    var child: PFlowController?
    var databaseService: DatabaseService?
    
    init(navCtrllr: UINavigationController, databaseService: DatabaseService) {
        navigationController = navCtrllr
        self.databaseService = databaseService
    }
    
    func start() {
        guard let vc = registerViewController else { return }
        
        let viewModel = RegisterViewModel(databaseService: databaseService!)
        viewModel.onFirstStepCompletion = { [weak self] in
            self?.moveToRegStep2()
        }
        
        vc.viewModel = viewModel
        navigationController.pushViewController(vc, animated: true)
    }
    
    func moveToRegStep2() {
        guard let regStep2VC = registerStep2ViewController else { return }
        let viewModel2 = RegisterStep2ViewModel()
        viewModel2.onThirdStep = { [weak self] in
            self?.moveToRegStep3()
        }
        regStep2VC.viewModel = viewModel2
        navigationController.pushViewController(regStep2VC, animated: false)
    }
    
    func moveToRegStep3() {
        guard let regStep3VC = registerStep3ViewController else { return }
        let viewModel3 = RegisterStep3ViewModel(databaseService: databaseService!)
        viewModel3.onMainScreen = { [weak self] in
            self?.onThirdStepNextTap?()
        }
        regStep3VC.viewModel = viewModel3
        navigationController.pushViewController(regStep3VC, animated: false)
    }
}

extension RegFlow {
    
    private var regSB: UIStoryboard {
        return UIStoryboard(name: Storyboard.register.rawValue, bundle: Bundle.main)
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
}
