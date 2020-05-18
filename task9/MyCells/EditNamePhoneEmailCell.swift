//
//  EditNamePhoneEmailCell.swift
//  task9
//
//  Created by Oksana Kotilevska on 2/6/20.
//  Copyright © 2020 Oksana Kotilevska. All rights reserved.
//

import UIKit

class EditNamePhoneEmailCell: UITableViewCell {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var label: UILabel!
    
    func  update(with viewModel: CellManagment) {
        textField.text = viewModel.text ?? ""
        label.text = viewModel.title
        textField.placeholder = viewModel.holder
    }
    
}

