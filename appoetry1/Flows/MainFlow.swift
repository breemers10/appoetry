//
//  MainFlow.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 25.02.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

class MainFlow: PFlowController {
    
    var onCompletion: (() -> Void)?
    fileprivate var childFlow: PFlowController?
    private var presenterVC: UIViewController
    
    init(with controller: UIViewController) {
        presenterVC = controller
    }
    
    func start() {
        guard let vc = mainViewController else { return }
        
        let viewModel = MainViewModel()
        viewModel.onCompletion = { [weak self] in
            self?.onCompletion?()
        }
        vc.viewModel = viewModel
        presenterVC.present(vc, animated: false, completion: nil)
    }
}

extension MainFlow {
    
    fileprivate var mainSB: UIStoryboard {
        return UIStoryboard(name: Storyboard.main.rawValue, bundle: Bundle.main)
    }
    
    fileprivate var mainViewController: MainViewController? {
        return mainSB.instantiateViewController(withIdentifier: MainViewController.className) as? MainViewController
    }
}
