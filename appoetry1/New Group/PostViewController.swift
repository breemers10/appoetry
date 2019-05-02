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
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var unfavoriteButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    
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
                self.favoritesLabel.text = "\(usersPost.favorites!) Favorites"
                self.postID = usersPost.postID
                self.genreLabel.text = usersPost.genre
                self.dateLabel.text = usersPost.createdAt!.calendarTimeSinceNow()
                
                for person in usersPost.peopleFavorited {
                    if person == Auth.auth().currentUser!.uid {
                        self.favoriteButton.isHidden = true
                        self.unfavoriteButton.isHidden = false
                        break
                    }
                }
            }
        })
    }
    
    @IBAction func favoriteButtonPressed(_ sender: Any) {
        favoriteButton.isHidden = false
        viewModel?.favoritePost(postID: postID, with: { (favorited) in
            if !favorited {
                self.favoritesLabel.text = "\((self.viewModel?.databaseService?.count)!) Favorites"
                
                self.favoriteButton.isHidden = true
                self.unfavoriteButton.isHidden = false
                self.favoriteButton.isEnabled = true
            }
        })
    }
    
    @IBAction func unfavoriteButtonPressed(_ sender: Any) {
        unfavoriteButton.isEnabled = false
        viewModel?.unfavoritePost(postID: postID, with: { (unfavorited) in
            if !unfavorited {
                self.favoritesLabel.text = "\((self.viewModel?.databaseService?.count)!) Favorites"
                self.favoriteButton.isHidden = false
                self.unfavoriteButton.isHidden = true
                self.unfavoriteButton.isEnabled = true
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

