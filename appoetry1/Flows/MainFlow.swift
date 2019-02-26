//
//  MainFlow.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 25.02.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

class MainFlow: FlowController {
    
    let rootController = UINavigationController()
    
    private lazy var mainSB: UIStoryboard = {
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }()
    
    private var mainViewController: MainViewController? {
        return mainSB.instantiateViewController(withIdentifier: "MainVC") as? MainViewController
    }
    
    func start() {
        guard let vc = mainViewController else {
            fatalError("Could not get main vc")
        }

        self.rootController.pushViewController(vc, animated: true)
    }
}
