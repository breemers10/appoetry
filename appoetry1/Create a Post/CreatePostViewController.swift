//
//  CreatePostViewController.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 07.03.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit
import Firebase

class CreatePostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var selectPhotoButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var previewImage: UIImageView!
    
    var viewModel: CreatePostViewModel?
    var picker = UIImagePickerController()
    var user: [UserInfo] = []
    var username: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.previewImage.image = image
            selectPhotoButton.isHidden = true
            postButton.isHidden = false
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectPhotoButtonPressed(_ sender: Any) {
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction func postButtonPressed(_ sender: Any) {
        
        AppDelegate.instance().showActivityIndicator()
        
        let uid = Auth.auth().currentUser!.uid
        MySharedInstance.instance.ref.child("users").child(uid).observe(.childAdded, with: { (snapshot) in
            if snapshot.key == "username" {
                self.username = snapshot.value as? String
            }
        })
        
        let key = MySharedInstance.instance.ref.child("posts").childByAutoId().key
        let storage = Storage.storage().reference(forURL : "gs://appoetry1.appspot.com")
        
        let imageRef = storage.child("posts").child(uid).child("\(String(describing: key)).jpg")
        
        let data = previewImage.image!.jpegData(compressionQuality: 0.6)
        
        let uploadTask = imageRef.putData(data!, metadata: nil) { (metadata, error) in
            if error != nil {
                print(error!.localizedDescription)
                AppDelegate.instance().dismissActivityIndicator()
                return
            }
            
            imageRef.downloadURL(completion: { (url, error) in
                if let url = url {
                    let feed = ["userID" : uid,
                                "poem" : self.textView.text,
                                "pathToImage" : url.absoluteString,
                                "favourites" : 0,
                                "author" : self.username!,
                                "postID" : key! ] as [String : Any]
                    let postFeed = ["\(String(describing: key))" : feed]
                    
                    MySharedInstance.instance.ref.child("posts").updateChildValues(postFeed)
                    
                    AppDelegate.instance().dismissActivityIndicator()
                    self.viewModel?.onMainScreen?()
                }
            })
        }
        uploadTask.resume()
    }
}

extension CreatePostViewController: ClassName {
    static var className: String {
        return String(describing: self)
    }
}
