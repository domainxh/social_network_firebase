//
//  PostCell.swift
//  Social_Network_Firebase
//
//  Created by Xiaoheng Pan on 1/12/17.
//  Copyright © 2017 Xiaoheng Pan. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var postedImage: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likeLabel: UILabel!
    
    func configureCell() {
        
    }

}
