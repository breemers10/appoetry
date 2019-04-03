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
        viewModel?.openPost()
        guard let post = viewModel?.databaseService?.usersPost else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            guard let url = URL(string: post.pathToImage!) else { return }
            self.poemImage.kf.setImage(with: url)
            self.authorLabel.text = post.username
            self.textView.text = post.poem
            self.favouritesLabel.text = "\(post.favourites!) Favourites"
            self.postID = post.postID
            self.genreLabel.text = post.genre
            self.dateLabel.text = post.createdAt!.calendarTimeSinceNow()
            
            for person in post.peopleFavourited {
                if person == Auth.auth().currentUser!.uid {
                    self.favouriteButton.isHidden = true
                    self.unfavouriteButton.isHidden = false
                    break
                }
            }
        }
    }
    
    @IBAction func favouriteButtonPressed(_ sender: Any) {
        favouriteButton.isHidden = false
        viewModel?.favouritePost(postID: postID)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if (self.viewModel?.databaseService?.favourited)! {
                self.favouritesLabel.text = "\((self.viewModel?.databaseService?.count)!) Favourites"
                self.favouriteButton.isHidden = true
                self.unfavouriteButton.isHidden = false
                self.favouriteButton.isEnabled = true
            }
        }
    }
    
    @IBAction func unfavouriteButtonPressed(_ sender: Any) {
        unfavouriteButton.isEnabled = false
        viewModel?.unfavouritePost(postID: postID)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if (self.viewModel?.databaseService?.unfavourited)! {
                self.favouritesLabel.text = "\((self.viewModel?.databaseService?.count)!) Favourites"
                self.favouriteButton.isHidden = false
                self.unfavouriteButton.isHidden = true
                self.unfavouriteButton.isEnabled = true
            }
        }
    }
    
    @IBAction func authorButtonPressed(_ sender: Any) {
        viewModel?.onAuthorTap?(postID)
    }
}

extension PostViewController: ClassName {
    static var className: String {
        return String(describing: self)
    }
}

