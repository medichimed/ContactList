//
//  UserModel.swift
//  task9
//
//  Created by Oksana Kotilevska on 1/2/20.
//  Copyright © 2020 Oksana Kotilevska. All rights reserved.
//
import UIKit
import Foundation

struct ContactModel{
    
    private let const = 0.393701
    
    var contactId: String?
    var firstName: String?
    var secondName: String?
    var phone: String?
    var email: String?
    var photoHasBeenUpdated = false
    
    var birthday: String?
    var height: String?
    var driverLicense: String?
    
    var image: UIImage{
        return StorageService.getImage(key: contactId!)
    }
    
    var convertedHeight: String? {
        
        let currentLanguage = NSLocale.preferredLanguages[0]
        
        if let height = height{
            if currentLanguage.starts(with: "uk"){
                return "\(height) cm"
            }else{
            
                let cm = Double(height)!
                let inch = cm * const
                
                let formatter = NumberFormatter()
                formatter.usesSignificantDigits = false
                formatter.minimumIntegerDigits = 0
                formatter.minimumFractionDigits = 0
                formatter.maximumFractionDigits = 0
                
                let result = formatter.string(from: inch as NSNumber)!
                return "\(result) inches"
            }
        }
        
        return nil
    }
    
    var toDictionary: [String: Any] {
        var dict : [String: Any] = [:]
        
        if let firstName = firstName{
            dict["firstName"] = firstName
        }
        if let secondName = secondName{
            dict["secondName"] = secondName
        }
        if let phone = phone{
            dict["phone"] = phone
        }
        if let email = email{
            dict["email"] = email
        }
        
        dict["hasPhoto"] = hasAvatar
        dict["contactId"] = contactId
        
        if let birthday = birthday{
            dict["birthday"] = birthday
        }
        if let height = height{
            dict["height"] = height
        }
        if let driverLicense = driverLicense{
            dict["driverLicense"] = driverLicense
        }
        return dict
    }
    
    var isNew: Bool {
        return contactId == nil
    }
    
    var hasAvatar: Bool {
        return photoHasBeenUpdated == true
    }
    
    var displayName: String{
        let nameArray = [firstName, secondName]
        let result = nameArray.compactMap{$0}.joined(separator: " ")

        return result.isEmpty ? phone ?? email ?? "" : result
        
    }
    
    init(firstName: String? = nil, secondName: String? = nil, phone: String? = nil, email: String? = nil){
        self.firstName = firstName
        self.secondName = secondName
        self.phone = phone
        self.email = email
    }
    
    init(contactDictionary: [String: Any]){
 
        firstName = contactDictionary["firstName"] as? String

        secondName = contactDictionary["secondName"] as? String

        phone = contactDictionary["phone"] as? String

        email = contactDictionary["email"] as? String

        contactId = contactDictionary["contactId"] as? String
        
        birthday = contactDictionary["birthday"] as? String
        
        height = contactDictionary["height"] as? String
        
        driverLicense = contactDictionary["driverLicense"] as? String
        
        photoHasBeenUpdated = contactDictionary["hasPhoto"] as? Bool ?? false
        
    }
    
    func saveImage(img: UIImage){
        StorageService.saveImage(contactId: contactId!, avatar: img)
    }

    mutating func setContactId(){
        self.contactId = UUID().uuidString
    }
    
    private func isValidPhone(phoneStr: String) -> Bool {
        let phoneRegEx = "[+]?[0-9]{12}"

        let phonePred = NSPredicate(format:"SELF MATCHES %@", phoneRegEx)
        return phonePred.evaluate(with: phoneStr)

    }
    
    private func isValidEmail(emailStr: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailStr)
    }
    
    func validate() -> ValidationResult {

        guard !(firstName ?? "").isEmpty || !(secondName ?? "").isEmpty || !(phone ?? "").isEmpty || !(email ?? "").isEmpty else { return .empty}
        
        if let email = email, !isValidEmail(emailStr: email){
            return .invalidEmail
        }
        
        if let phone = phone, !isValidPhone(phoneStr: phone){
            return .invalidPhone
        }
        
        return .valid
    }
    
    enum ValidationResult{
        case valid
        case empty
        case invalidPhone
        case invalidEmail
        
        var description: String? {
            switch self{
            case .invalidPhone: return "Invalid phone number"
            case .invalidEmail: return "Invalid email"
            case .empty: return "Empty fields"
            default: return nil
            }
        }
    }
    
}

extension ContactModel: Comparable {
    
    static func < (lhs: ContactModel, rhs: ContactModel) -> Bool {
        return lhs.displayName.lowercased() < rhs.displayName.lowercased()
    }
    
}
