//
//  MainFeedViewCell.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 15.03.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit
import Firebase

class MainFeedViewCell: UICollectionViewCell {
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var unfavouriteButton: UIButton!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var favouritesLabel: UILabel!
    
    var postID: String!
    
    @IBAction func favouriteBttnPressed(_ sender: Any) {
        self.favouriteButton.isHidden = false
        let keyToPost = MySharedInstance.instance.ref.child("posts").childByAutoId().key!
        
        MySharedInstance.instance.ref.child("posts").child(self.postID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let post = snapshot.value as? [String: AnyObject] {
                let updateFavourites: [String : Any] = [ "peopleFavourited/\(keyToPost)" : Auth.auth().currentUser!.uid]
                MySharedInstance.instance.ref.child("posts").child(self.postID).updateChildValues(updateFavourites, withCompletionBlock: { (error, ref) in
                    if error == nil {
                        MySharedInstance.instance.ref.child("posts").child(self.postID).observeSingleEvent(of: .value, with: { (snap) in
                            if let properties = snap.value as? [String : AnyObject] {
                                if let favourites = properties["peopleFavourited"] as? [String : AnyObject] {
                                    let count = favourites.count
                                    self.favouritesLabel.text = "\(count) Favourites"
                                    
                                    let update = ["favourites" : count]
                                    MySharedInstance.instance.ref.child("posts").child(self.postID).updateChildValues(update)
                                    
                                    self.favouriteButton.isHidden = true
                                    self.unfavouriteButton.isHidden = false
                                    self.favouriteButton.isEnabled = true
                                }
                            }
                        })
                    }
                })
            }
        })
        MySharedInstance.instance.ref.removeAllObservers()
    }
    
    @IBAction func unfavouriteBttnPressed(_ sender: Any) {
        self.unfavouriteButton.isEnabled = false
        MySharedInstance.instance.ref.child("posts").child(self.postID).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let properties = snapshot.value as? [String : AnyObject] {
                if let peopleFavourited = properties["peopleFavourited"] as? [String : AnyObject] {
                    
                    
                    for (id, person) in peopleFavourited {
                        if person as? String == Auth.auth().currentUser!.uid {
                            MySharedInstance.instance.ref.child("posts").child(self.postID).child("peopleFavourited").child(id).removeValue(completionBlock: { (error, ref) in
                                if error == nil {
                                    MySharedInstance.instance.ref.child("posts").child(self.postID).observeSingleEvent(of: .value, with: { (snap) in
                                        if let prop = snap.value as? [String : AnyObject] {
                                            if let favourites = prop["peopleFavourited"] as? [String : AnyObject] {
                                                let count = favourites.count
                                                self.favouritesLabel.text = "\(count) Favourites"
                                                MySharedInstance.instance.ref.child("posts").child(self.postID).updateChildValues(["favourites" : count]) } else {
                                                self.favouritesLabel.text = "0 Favourites"
                                                MySharedInstance.instance.ref.child("posts").child(self.postID).updateChildValues(["favourites" : 0])
                                            }
                                        }
                                    })
                                }
                            })

                            self.favouriteButton.isHidden = false
                            self.unfavouriteButton.isHidden = true
                            self.unfavouriteButton.isEnabled = true
                            break
                            
                        }
                    }
                }
            }
        })
        
    }
}
