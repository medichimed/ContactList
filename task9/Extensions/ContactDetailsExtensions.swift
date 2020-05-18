//
//  ContactDetailsExtension.swift
//  task9
//
//  Created by Oksana Kotilevska on 1/9/20.
//  Copyright © 2020 Oksana Kotilevska. All rights reserved.
//

import UIKit

extension ContactDetailsViewController{
    
    func fillDetails(){
        
        imageViewAvatar.image = specificContact.image
        
        let barTitle = specificContact.displayName
        self.navigationItem.title = barTitle
        
        let leftItem = NSLocalizedString("backItem", comment: "Back")
        let rightItem = NSLocalizedString("forwardItem", comment: "Forward")
        
        navigationItem.leftBarButtonItem?.title = leftItem
        navigationItem.rightBarButtonItem?.title = rightItem
        
        labelNameFirst.text = specificContact.firstName ?? ""
        labelNameSecond.text = specificContact.secondName ?? ""
        labelPhone.text = specificContact.phone ?? ""
        labelEmail.text = specificContact.email ?? ""
        
        if !labelEmail.text!.isEmpty{
            let txt = NSLocalizedString("detailsEmail", comment: "Email")
            labelEmailTitle.text = txt
        }
        
        labelBirthday.text = specificContact.birthday ?? ""
        
        if !labelBirthday.text!.isEmpty{
            let txt = NSLocalizedString("detailsBirthday", comment: "Birthday")
            labelBirthdayTitle.text = txt
        }
        
        labelHeight.text = specificContact.convertedHeight ?? ""
        
        if !labelHeight.text!.isEmpty{
            let txt = NSLocalizedString("detailsHeight", comment: "Height")
            labelHeightTitle.text = txt
            labelHeight.text = labelHeight.text!
        }
        
        labelDriverLicense.text = specificContact.driverLicense ?? ""
        
        if !labelDriverLicense.text!.isEmpty{
            let txt = NSLocalizedString("detailsLicense", comment: "Driver's license")
            labelDriverLicenseTitle.text = txt
        }
    }
}

extension ContactDetailsViewController: PassData{
    func passContactDetails(newContact: ContactModel) {
        specificContact = newContact
        fillDetails()
    }
    
    func deleteContact(deletedContact: ContactModel) {
        passedDataDelegate.deleteContact(deletedContact: deletedContact)
        navigationController?.popViewController(animated: true)
    }
}
