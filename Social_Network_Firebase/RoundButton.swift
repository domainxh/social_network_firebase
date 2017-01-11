//
//  RoundButton.swift
//  Social_Network_Firebase
//
//  Created by Xiaoheng Pan on 1/11/17.
//  Copyright © 2017 Xiaoheng Pan. All rights reserved.
//

import UIKit

class RoundButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        // this is similar to viewDidLoad function
        
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        
        imageView?.contentMode = .scaleAspectFit
//        layer.cornerRadius = 10
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // You can also just leave this code in the awakeFromNib function.
        
        layer.cornerRadius = self.frame.width/2

        
    }

}
