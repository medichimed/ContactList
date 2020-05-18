//
//  EditBirthdayCell.swift
//  task9
//
//  Created by Oksana Kotilevska on 2/6/20.
//  Copyright © 2020 Oksana Kotilevska. All rights reserved.
//

import UIKit

class EditBirthdayCell: UITableViewCell {
    @IBOutlet weak var textFieldBirthday: UITextField!
    @IBOutlet weak var labelBirthday: UILabel!
    
    func  update(with viewModel: CellManagment) {
        textFieldBirthday.text = viewModel.text ?? ""
        labelBirthday.text = viewModel.title
        textFieldBirthday.placeholder = viewModel.holder
    }
}
