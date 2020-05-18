//
//  DeleteButtonCell.swift
//  task9
//
//  Created by Oksana Kotilevska on 2/6/20.
//  Copyright © 2020 Oksana Kotilevska. All rights reserved.
//

import UIKit

class DeleteButtonCell: UITableViewCell {
    @IBOutlet weak var buttonDelete: UIButton!
    var deleteClosure: (() -> ())?
    
    @IBAction func deletePressed(_ sender: UIButton){
        deleteClosure?()
    }
}
