//
//  EditPostViewController.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 08.05.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

class EditPostViewController: UIViewController {
    var viewModel: EditPostViewModel?
    var postID: String!
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchPost()
    }
    
    override func viewDidLayoutSubviews() {
        self.view.applyGradient()
    }
    
    private func fetchPost() {
        guard let usersPost = viewModel?.databaseService?.usersPost else { return }
        viewModel?.openPost(with: { (fetched) in
            if fetched {
                self.textView.text = usersPost.poem
                self.postID = usersPost.postID
            }
        })
    }
    
    @IBAction func deletePostButtonPressed(_ sender: Any) {
        viewModel?.deletePost(postID: postID)
        viewModel?.onSuccessfulDeletion?()
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        viewModel?.editPost(poem: textView.text, postID: postID)
        viewModel?.onSuccessfulEdit?()
    }
}
extension EditPostViewController: ClassName {
    static var className: String {
        return String(describing: self)
    }
}
