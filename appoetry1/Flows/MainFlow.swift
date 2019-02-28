//
//  MainFlow.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 25.02.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

class MainFlow: PFlowController {
    func start() {
        debugPrint("Will need this later ...")
    }
    
    var onCompletion: (() -> Void)?
    private var mainWindow: UIWindow
    
    init(with window: UIWindow) {
        self.mainWindow = window
    }
    
    private lazy var mainSB: UIStoryboard = {
        return UIStoryboard(name: Storyboard.main.rawValue, bundle: Bundle.main)
    }()
    
    private var mainViewController: MainViewController? {
        return mainSB.instantiateViewController(withIdentifier: MainViewController.className) as? MainViewController
    }
    
    func start(with completionHandler: @escaping (() -> Void)) {
        guard let vc = mainViewController else { return }
        let rootController = UINavigationController(rootViewController: vc)
        mainWindow.rootViewController = rootController
        mainWindow.makeKeyAndVisible()
        vc.onCompletion = { [weak self] in
            self?.onCompletion?()
        }
    }
}
