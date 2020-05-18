//
//  EditAvatarCell.swift
//  task9
//
//  Created by Oksana Kotilevska on 2/6/20.
//  Copyright © 2020 Oksana Kotilevska. All rights reserved.
//

import UIKit

class EditAvatarCell: UITableViewCell {
    var imageClosure: (()->())?
    
    @IBOutlet weak var imageViewAvatar: UIImageView!
    
    @IBAction func hendleImagePressed(_ sender: Any){
        imageClosure?()
    }
    
    func setAvatarImageCell(with image: UIImage){
        imageViewAvatar.image = image
    }
    
}

