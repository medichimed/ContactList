//
//  CellManagment.swift
//  task9
//
//  Created by Oksana Kotilevska on 2/14/20.
//  Copyright © 2020 Oksana Kotilevska. All rights reserved.
//

import UIKit

struct CellManagment{
    var title: String
    var holder: String
    var text: String?
    
    init(with contact: ContactModel, type: DataType){
        
        let description = type.description
        
        switch type{
        case .firstName:
            text = contact.firstName
        case .secondName:
            text = contact.secondName
        case .phone:
            text = contact.phone
        case .email:
            text = contact.email
        case .birthday:
            text = contact.birthday
        case .driverLicense:
            text = contact.driverLicense
        case .height:
            text = contact.convertedHeight
        }
        title = description.0
        holder = description.1
    }
    
    static let nameLabel = NSLocalizedString("editNameLabel", comment: "First Name")
    static let nameHolder = NSLocalizedString("editNameHolder", comment: "Text Holder")
    
    static let surnameLabel = NSLocalizedString("editSurnameLabel", comment: "Last Name")
    static let surnameHolder = NSLocalizedString("editSurnameHolder", comment: "Text Holder")
    
    static let phoneLabel = NSLocalizedString("editPhoneLabel", comment: "Phone")
    static let phoneHolder = NSLocalizedString("editPhoneHolder", comment: "Phone Holder")
    
    static let emailLabel = NSLocalizedString("editEmailLabel", comment: "Email")
    static let emailHolder = NSLocalizedString("editEmailHolder", comment: "Email Holder")
    
    static let birthdayLabel = NSLocalizedString("editBirthdayLabel", comment: "Birthday")
    static let birthdayHolder = NSLocalizedString("editBirthdayHolder", comment: "Birthday Holder")
    
    static let heightLabel = NSLocalizedString("editHeightLabel", comment: "Height")
    static let heightHolder = NSLocalizedString("editHeightHolder", comment: "Height Holder")
    
    static let licenseLabel = NSLocalizedString("editLicenseLabel", comment: "Driver License")
    static let licenseHolder = NSLocalizedString("editLicenseHolder", comment: "Driver License Holder")
    
    enum DataType{
        case firstName
        case secondName
        case phone
        case email
        case birthday
        case driverLicense
        case height
        
        var description: (String, String){
            switch self{
            case .firstName: return (nameLabel, nameHolder)
            case .secondName: return (surnameLabel, surnameHolder)
            case .phone: return (phoneLabel, phoneHolder)
            case .email: return (emailLabel, emailHolder)
            case .birthday: return (birthdayLabel, birthdayHolder)
            case .driverLicense: return(licenseLabel, licenseHolder)
            case .height: return(heightLabel, heightHolder)
            }
        }
    }
    
    
}
