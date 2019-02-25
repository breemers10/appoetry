//
//  RegisterStep2ViewController.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 25.02.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

class RegisterStep2ViewController: UIViewController {
    var showMeAgain: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backToStepOne(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("goToReg"), object: nil)
    }
    
    
}
