//
//  BorderedImage.swift
//  task9
//
//  Created by Oksana Kotilevska on 1/13/20.
//  Copyright © 2020 Oksana Kotilevska. All rights reserved.
//

import UIKit

@IBDesignable
class BorderedImage: UIImageView {

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = cornerRadius * self.frame.size.height
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = UIColor.black.cgColor
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0.1
    @IBInspectable var borderWidth: CGFloat = 1.0
}
