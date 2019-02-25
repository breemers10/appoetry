//
//  LoginViewController.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 25.02.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var emailLogin: UITextField!
    @IBOutlet weak var passwordLogin: UITextField!
    
    var showMeAgain: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func pressLogin(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("goToMain"), object: nil)
    }
    @IBAction func pressRegister(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("goToReg"), object: nil)
    }
    
    
}
