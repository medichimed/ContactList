//
//  EditDriverLicenseCell.swift
//  task9
//
//  Created by Oksana Kotilevska on 2/6/20.
//  Copyright © 2020 Oksana Kotilevska. All rights reserved.
//

import UIKit

class EditDriverLicenseCell: UITableViewCell {
    
    @IBOutlet weak var textFieldLicense: UITextField!
    @IBOutlet weak var labelLicense: UILabel!
    @IBOutlet weak var switcher: UISwitch!
    
    func  update(with viewModel: CellManagment) {
        textFieldLicense.text = viewModel.text ?? ""
        labelLicense.text = viewModel.title
        textFieldLicense.placeholder = viewModel.holder
        
        let hasNoLicense = textFieldLicense.text!.isEmpty
        
        switcher.isOn = !hasNoLicense
        textFieldLicense.isHidden = hasNoLicense
    }

    @IBAction func switcheToggled(_ sender: UISwitch) {
        textFieldLicense.isHidden = !sender.isOn
        setNeedsLayout()
        setNeedsDisplay()
    }
    
}
