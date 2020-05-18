//
//  ContactDetailsViewController.swift
//  task9
//
//  Created by Oksana Kotilevska on 12/30/19.
//  Copyright © 2019 Oksana Kotilevska. All rights reserved.
//

import UIKit

class ContactDetailsViewController: UIViewController {
    

    var specificContact: ContactModel!
    weak var passedDataDelegate: PassData!
    
    @IBOutlet weak var imageViewAvatar: UIImageView!
    @IBOutlet weak var labelNameFirst: UILabel!
    @IBOutlet weak var labelNameSecond: UILabel!
    @IBOutlet weak var labelPhone: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    
    @IBOutlet weak var labelBirthday: UILabel!
    @IBOutlet weak var labelHeight: UILabel!
    @IBOutlet weak var labelDriverLicense: UILabel!
    
    @IBOutlet weak var labelEmailTitle: UILabel!
    @IBOutlet weak var labelBirthdayTitle: UILabel!
    @IBOutlet weak var labelHeightTitle: UILabel!
    @IBOutlet weak var labelDriverLicenseTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fillDetails()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        passedDataDelegate.passContactDetails(newContact: specificContact)
        self.navigationController?.popViewController(animated: true)
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "toEditPage"{
            if let targetController = segue.destination as? EditPageTableViewController{
                targetController.passedContact = specificContact
                targetController.passedDataDelegate = self 
            }
        }
    }
}


