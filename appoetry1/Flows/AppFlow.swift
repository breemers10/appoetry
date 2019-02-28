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
    
    init(with window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let loginFlow = LoginFlow(with: window)
        loginFlow.start(with: {
            debugPrint("Let's get this party started!")
        })
        childFlow = loginFlow
        
    }
}
