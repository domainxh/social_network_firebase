//
//  FancyField.swift
//  Social_Network_Firebase
//
//  Created by Xiaoheng Pan on 1/11/17.
//  Copyright © 2017 Xiaoheng Pan. All rights reserved.
//

import UIKit

class FancyField: UITextField {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.borderColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.2).cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 5
        
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        // This will impact your text placeholder
        
        return bounds.insetBy(dx: 10, dy: 0)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        // This will impact your actual text placement
        
        return bounds.insetBy(dx: 10, dy: 0)
    }
}
