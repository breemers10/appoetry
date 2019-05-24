//
//  PostViewController.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 01.04.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import Kingfisher

final class PostViewController: UIViewController {
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var poemImage: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var authorButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    
    var viewModel: PostViewModel?
    private var postID: String!
    private var isFavorited = false
    
    private let favoriteImage = UIImage.favorite
    private let unfavoriteImage = UIImage.unfavorite
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchPost()
    }
    
    override func viewDidLayoutSubviews() {
        self.view.applyGradient()
    }
    
    private func fetchPost() {
        guard let usersPost = viewModel?.databaseService?.usersPost else { return }
        viewModel?.openPost(with: { [weak self] (fetched) in
            if fetched {
                guard let imageUrl = usersPost.pathToImage else { return }
                guard let url = URL(string: imageUrl) else { return }
                self?.poemImage.kf.setImage(with: url)
                self?.authorLabel.text = usersPost.username
                self?.textView.text = usersPost.poem
                self?.favoritesLabel.text = "\(usersPost.favorites!) Favorites"
                self?.postID = usersPost.postID
                self?.genreLabel.text = usersPost.genre
                self?.dateLabel.text = usersPost.createdAt!.calendarTimeSinceNow()
                
                let favourited = usersPost.peopleFavorited.contains(DatabaseService.instance.currentUserID!)
                self?.isFavorited = favourited
                if (self?.isFavorited)! {
                    self?.favoriteButton.setImage(self?.favoriteImage, for: UIControl.State.normal)
                } else {
                    self?.favoriteButton.setImage(self?.unfavoriteImage, for: UIControl.State.normal)
                }
            }
        })
    }
    
    private func favoritePost() {
        viewModel?.favoritePost(postID: postID, with: { [weak self] (favorited) in
            if favorited {
                self?.isFavorited = true
                guard let count = self?.viewModel?.databaseService?.count else { return }
                self?.favoritesLabel.text = "\(count) Favorites"
                self?.favoriteButton.setImage(self?.favoriteImage, for: UIControl.State.normal)
                
            }
        })
    }
    
    private func unfavoritePost() {
        viewModel?.unfavoritePost(postID: postID, with: { [weak self] (unfavorited) in
            if unfavorited {
                self?.isFavorited = false
                guard let count = self?.viewModel?.databaseService?.count else { return }
                self?.favoritesLabel.text = "\(count) Favorites"
                self?.favoriteButton.setImage(self?.unfavoriteImage, for: UIControl.State.normal)
            }
        })
    }
    
    @IBAction func favoriteButtonPressed(_ sender: Any) {
        isFavorited ? unfavoritePost() : favoritePost()

    }
    
    @IBAction func authorButtonPressed(_ sender: Any) {
        guard let userId = viewModel?.databaseService?.usersPost.userID else { return }
        viewModel?.onAuthorTap?(userId)
    }
}
