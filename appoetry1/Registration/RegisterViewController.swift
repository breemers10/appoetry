//
//  RegisterViewController.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 25.02.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var registerEmail: UITextField!
    @IBOutlet weak var registerPassword: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var uploadButton: UIButton!
    
    var viewModel: RegisterViewModel?
    var picker = UIImagePickerController()
    var user: [UserInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        
        imageView.image = UIImage(named: "user-default")
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        imageView.isUserInteractionEnabled = true
    }
    
    override func viewDidLayoutSubviews() {
        self.view.applyGradient()
    }
    
    @objc func handleSelectProfileImageView() {
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.imageView.image = image
            uploadButton.isHidden = true
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func uploadPhotoButtonPressed(_ sender: Any) {
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction func nextFromFirstStep(_ sender: Any) {
        let providedEmailAddress = registerEmail.text
        let providedPassword = registerPassword.text
        
        let isEmailAddressValid = isValidEmailAddress(emailAddressString: providedEmailAddress!)
        let isEmailAddressUsed = isEmailAlreadyTaken(emailAddressString: providedEmailAddress!)
        let isPasswordValid = isValidPassword(testStr: providedPassword)
        
        if isEmailAddressValid {
            
        } else {
            print("Email address is not valid")
            displayAlertMessage(messageToDisplay: "Email address is not valid")
        }
        
        if isEmailAddressUsed {
            self.displayAlertMessage(messageToDisplay: "User with this email already exists!")
        } else {
            print("Email is not taken so you can use it!")
        }
        
        if isPasswordValid {
            print("Password is valid")
        } else {
            print("Password is not valid")
            displayAlertMessage(messageToDisplay: "Password is not valid")
        }
        
        if self.confirmPassword.text == self.registerPassword.text {
            print("All good Senjor")
            guard
                let email = registerEmail.text,
                let password = registerPassword.text
                else { return }
            
            guard let data = imageView.image!.jpegData(compressionQuality: 0.6) else { return }

            viewModel?.storeUsersPhoto(data: data, with: { [weak self] (url) in
                self?.viewModel?.addCredentials(email: email, password: password, imageUrl: url.absoluteString)
            })
        } else {
            print("Passwords does not match!")
            displayAlertMessage(messageToDisplay: "Passwords does not match!")
        }
        self.viewModel?.secondStep()
    }
    func isValidEmailAddress(emailAddressString: String) -> Bool {
        
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        return returnValue
    }
    
    func isEmailAlreadyTaken(emailAddressString: String) -> Bool {
        var itIsUsed = false
        
        DatabaseService.instance.ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
//            let value = snapshot.value as! [String : AnyObject]
            
//            value.forEach({ (key: "email", value: AnyObject) in
//                guard let email = { $0.value } else { return }
//                if email = value {
//                    return itIsUsed

//                }
//            })
        })
        return itIsUsed
    }
    
    func isValidPassword(testStr:String?) -> Bool {
        guard testStr != nil else { return false }
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}")
        return passwordTest.evaluate(with: testStr)
    }
    
    func displayAlertMessage(messageToDisplay: String) {
        let alertController = UIAlertController(title: "Alert", message: messageToDisplay, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            
            print("Ok button tapped");
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion:nil)
    }
}

extension RegisterViewController: ClassName {
    static var className: String {
        return String(describing: self)
    }
}
