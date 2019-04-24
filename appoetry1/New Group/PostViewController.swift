//
//  PostViewController.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 01.04.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit
import Firebase

class PostViewController: UIViewController {
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var poemImage: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var authorButton: UIButton!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var unfavouriteButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var favouritesLabel: UILabel!
    
    var viewModel: PostViewModel?
    var postID: String!
    
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
                guard let url = URL(string: usersPost.pathToImage!) else { return }
                self.poemImage.kf.setImage(with: url)
                self.authorLabel.text = usersPost.username
                self.textView.text = usersPost.poem
                self.favouritesLabel.text = "\(usersPost.favourites!) Favourites"
                self.postID = usersPost.postID
                self.genreLabel.text = usersPost.genre
                self.dateLabel.text = usersPost.createdAt!.calendarTimeSinceNow()
                
                for person in usersPost.peopleFavourited {
                    if person == Auth.auth().currentUser!.uid {
                        self.favouriteButton.isHidden = true
                        self.unfavouriteButton.isHidden = false
                        break
                    }
                }
            }
        })
    }
    
    @IBAction func favouriteButtonPressed(_ sender: Any) {
        favouriteButton.isHidden = false
        viewModel?.favouritePost(postID: postID, with: { (favorited) in
            if !favorited {
                self.favouritesLabel.text = "\((self.viewModel?.databaseService?.count)!) Favourites"
                
                self.favouriteButton.isHidden = true
                self.unfavouriteButton.isHidden = false
                self.favouriteButton.isEnabled = true
            }
        })
    }
    
    @IBAction func unfavouriteButtonPressed(_ sender: Any) {
        unfavouriteButton.isEnabled = false
        viewModel?.unfavouritePost(postID: postID, with: { (unfavorited) in
            if !unfavorited {
                self.favouritesLabel.text = "\((self.viewModel?.databaseService?.count)!) Favourites"
                self.favouriteButton.isHidden = false
                self.unfavouriteButton.isHidden = true
                self.unfavouriteButton.isEnabled = true
            }
        })
    }
    
    @IBAction func authorButtonPressed(_ sender: Any) {
        guard let userId = viewModel?.databaseService?.usersPost.userID else { return }
        viewModel?.onAuthorTap?(userId)
    }
}

extension PostViewController: ClassName {
    static var className: String {
        return String(describing: self)
    }
}

