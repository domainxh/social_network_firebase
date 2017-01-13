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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var postedImage: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likeLabel: UILabel!
    
    func configureCell(_ post: Post, img: UIImage? = nil) {
        // = nil will give configureCell the default value of nil for image. 
        
        self.post = post
        
        caption.text = post.captions
        likeLabel.text = "\(post.likes)"
        
        if img != nil {
            self.postedImage.image = img
        } else {
            let ref = FIRStorage.storage().reference(forURL: post.ImageURL)
            ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print("Unable to download image from firebase storage: \(error)")
                } else {
                    print("Image downloaded from firebase storage")
                    if let imgData = data {
                        if let img = UIImage(data: imgData) {
                            self.postedImage.image = img
                            FeedVC.imageCache.setObject(img, forKey: post.ImageURL as NSString)
                        }
                    }
                }

            })
            
        }
        
    }

}
