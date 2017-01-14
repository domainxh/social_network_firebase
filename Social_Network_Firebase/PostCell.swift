//
//  PostCell.swift
//  Social_Network_Firebase
//
//  Created by Xiaoheng Pan on 1/12/17.
//  Copyright © 2017 Xiaoheng Pan. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {

    var post: Post!
    var likeRef: FIRDatabaseReference!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        tap.numberOfTapsRequired = 1
        likeButton.addGestureRecognizer(tap)
        likeButton.isUserInteractionEnabled = true
    }

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var postedImage: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var likeButton: UIImageView!
    
    func configureCell(post: Post, img: UIImage? = nil) {
        // = nil will give configureCell the default value of nil for image. 
        
        self.post = post
        
        likeRef = DataService.ds.REF_USER_CURRENT.child("likes").child(post.postKey)
        caption.text = post.captions
        likeLabel.text = "\(post.likes)"
        
        if img != nil {
            self.postedImage.image = img
        } else {
            let ref = FIRStorage.storage().reference(forURL: post.ImageURL)
            ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                // This downloads the file asyncronously with a max size to NSData
                
                if error != nil {
                    print("Unable to download image from firebase storage: \(error)")
                } else {
                    print("Image downloaded from firebase storage")
                    if let imgData = data {
                        if let img = UIImage(data: imgData) {
                            self.postedImage.image = img
                            FeedVC.imageCache.setObject(img, forKey: post.ImageURL as NSString)
                            // This stores the image in the imageCache
                        }
                    }
                }
            })
        }
        
        likeRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likeButton.image = UIImage(named: "empty-heart")
            } else {
                self.likeButton.image = UIImage(named: "filled-heart")
            }
        })
    }
    
    func likeTapped(sender: UITapGestureRecognizer) {
        likeRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likeButton.image = UIImage(named: "filled-heart")
                self.post.adjustLikes(addLike: true)
                self.likeRef.setValue(true) //If the user likes it, we need to set the value in firebase user to "true"
            } else {
                self.likeButton.image = UIImage(named: "empty-heart")
                self.post.adjustLikes(addLike: false)
                self.likeRef.removeValue()
            }
        })
    }
    
}
