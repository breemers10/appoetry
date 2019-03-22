//
//  EditProfileViewController.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 22.03.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var fullnameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var firstGenreField: UITextField!
    @IBOutlet weak var secondGenreField: UITextField!
    @IBOutlet weak var thirdGenreField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var changePhotoButton: UIButton!
    
     var viewModel: EditProfileViewModel?
    
    let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        imageView.isUserInteractionEnabled = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            self.usernameField.text = self.viewModel?.username
            self.fullnameField.text = self.viewModel?.fullName
            self.emailField.text = self.viewModel?.email
            self.firstGenreField.text = self.viewModel?.firstGenre
            self.secondGenreField.text = self.viewModel?.secondGenre
            self.thirdGenreField.text = self.viewModel?.thirdGenre

            self.imageView.downloadImage(from: self.viewModel?.imageUrl)
        }
    }
    
    override func viewDidLayoutSubviews() {
        self.view.applyGradient()
        self.doneButton.applyButtonDesign()
    }
    
    @IBAction func changePhotoButtonPressed(_ sender: Any) {
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        viewModel?.onEditProfileCompletion?()
    }
    
    @objc func handleSelectProfileImageView() {
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.imageView.image = image
            changePhotoButton.isHidden = true
        }
        self.dismiss(animated: true, completion: nil)
    }
}
extension EditProfileViewController: ClassName {
    static var className: String {
        return String(describing: self)
    }
}
