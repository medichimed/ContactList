//
//  contactCell.swift
//  task9
//
//  Created by Oksana Kotilevska on 12/30/19.
//  Copyright © 2019 Oksana Kotilevska. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell{
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()

        avatarImage.layer.cornerRadius = avatarImage.frame.size.height / 2
        avatarImage.clipsToBounds = true
    }

}
