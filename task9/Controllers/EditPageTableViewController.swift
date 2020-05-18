//
//  EditPageTableViewController.swift
//  task9
//
//  Created by Oksana Kotilevska on 2/5/20.
//  Copyright © 2020 Oksana Kotilevska. All rights reserved.
//

import UIKit

class EditPageTableViewController: UITableViewController {
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    var passedContact: ContactModel!
       weak var passedDataDelegate: PassData!
       var avatarImage: UIImage?
       var currentCell: CellHandbook?

       var heightDigits: [Int] = [0,0,0]
       
       override func viewDidLoad() {
           super.viewDidLoad()
        
        tableView.delegate = self
        
       if passedContact == nil {
           passedContact = ContactModel(firstName: nil, secondName: nil, phone: nil, email: nil)
       }
           
        setFunctionalityForNavigationBar()
       }

}

enum CellHandbook: Int{
    case firstName = 1, lastName, phone, email, birthday, height, driverLicense
}
