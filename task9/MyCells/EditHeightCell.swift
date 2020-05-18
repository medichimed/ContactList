//
//  EditHeightCell.swift
//  task9
//
//  Created by Oksana Kotilevska on 2/6/20.
//  Copyright © 2020 Oksana Kotilevska. All rights reserved.
//

import UIKit

class EditHeightCell: UITableViewCell {
    @IBOutlet weak var textFieldHeight: UITextField!
    @IBOutlet weak var labelHeight: UILabel!
    
    func  update(with viewModel: CellManagment) {
        textFieldHeight.text = viewModel.text ?? ""
        labelHeight.text = viewModel.title
        textFieldHeight.placeholder = viewModel.holder
    }
    
    func updateHeightTextField( didUpdateWith: () -> String){
        textFieldHeight.text = didUpdateWith()
    }
}

