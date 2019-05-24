//
//  EditPostViewController.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 08.05.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

final class EditPostViewController: UIViewController {
    var viewModel: EditPostViewModel?
    private var postID: String!
    
    @IBOutlet private weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchPost()
        createToolbar()
    }
    
    override func viewDidLayoutSubviews() {
        self.view.applyGradient()
    }
    
    private func fetchPost() {
        guard let usersPost = viewModel?.databaseService?.usersPost else { return }
        viewModel?.openPost(with: { [weak self] (fetched) in
            if fetched {
                self?.textView.text = usersPost.poem
                self?.postID = usersPost.postID
            }
        })
    }
    
    @IBAction private func deletePostButtonPressed(_ sender: Any) {
        viewModel?.deletePost(postID: postID)
        viewModel?.onSuccessfulDeletion?()
    }
    
    @IBAction private func doneButtonPressed(_ sender: Any) {
        viewModel?.editPost(poem: textView.text, postID: postID)
        viewModel?.onSuccessfulEdit?()
    }
    
    private func createToolbar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(EditPostViewController.dismissKeyboard))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        textView.inputAccessoryView = toolBar
        
        toolBar.barTintColor = .white
        toolBar.backgroundColor = .white
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
