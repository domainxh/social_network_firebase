//
//  CircleImageView.swift
//  Social_Network_Firebase
//
//  Created by Xiaoheng Pan on 1/12/17.
//  Copyright © 2017 Xiaoheng Pan. All rights reserved.
//

import UIKit

class CircleImageView: UIImageView {
    
    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = self.frame.width / 2
    }

}
