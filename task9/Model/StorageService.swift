//
//  StorageService.swift
//  task9
//
//  Created by Oksana Kotilevska on 1/27/20.
//  Copyright © 2020 Oksana Kotilevska. All rights reserved.
//

import UIKit

struct StorageService{
    static let key = "contactStorage"
    
    static func deleteContact(keyId: String) {
        var defaults = UserDefaults.standard.array(forKey: key) as? [[String: Any]] ?? []
        
        defaults.removeAll { (contactItem) -> Bool in
            return contactItem["contactId"] as? String == keyId
        }
        
        removeAvatarFromStorage(path: keyId)
        
        DimensionalConverter.setUserDefaults(dictionary: defaults)
    }
    
    static func removeAvatarFromStorage(path: String){
        
        guard let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fullPath = documentURL.appendingPathComponent(path + ".png")
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(at: fullPath)
        }catch let error{
            print("Error occured during deliting files: ", error)
        }
    }
    
    static func updateUserDefaults(with newContact: ContactModel){
        var defaults = UserDefaults.standard.array(forKey: key) as? [[String: Any]] ?? []
        
        if let existingIndex = defaults.firstIndex(where: { return $0["contactId"] as? String == newContact.contactId}){
            
            let contactDictionary = newContact.toDictionary
            
            defaults[existingIndex] = contactDictionary
            
            DimensionalConverter.setUserDefaults(dictionary: defaults)
            
        }

    }
    
     static func deleteContactAndAvatarUpdateDefaults(deletedContact: ContactModel){
        var defaults = UserDefaults.standard.array(forKey: key) as? [[String: Any]] ?? []
        
        if let deletedIndex = defaults.firstIndex(where: {
            return $0["contactId"] as? String == deletedContact.contactId
        }){
            defaults.remove(at: deletedIndex)
            UserDefaults.standard.set(defaults, forKey: key)
            
            if deletedContact.hasAvatar{
                StorageService.removeAvatarFromStorage(path: deletedContact.contactId!)
            }
        }
    }
    
    static func saveImage(contactId: String, avatar: UIImage){
        ImageStorage.saveImage(key: contactId, img: avatar)
    }
    
    static func getImage(key: String) -> UIImage{
        return ImageStorage.getImage(for: key)
    }
    
    static func addContact(newContact: [String: Any]) {
        var defaults = UserDefaults.standard.array(forKey: key) as? [[String: Any]] ?? []
        defaults.append(newContact)
        DimensionalConverter.setUserDefaults(dictionary: defaults)
    }
    
    static func getStoredData() -> [[String: Any]] {
        return UserDefaults.standard.array(forKey: StorageService.key) as? [[String: Any]] ?? []
    }
    
    static func convertSourceIntoTwoDimensions(from data: [ContactModel]) -> [StoredData] {
       return DimensionalConverter.getTwoDimensionalDataSource(source: data) ?? []
    }
    
    static func convertSourceIntoOneDimension(from data: [StoredData]) -> [ContactModel] {
        return DimensionalConverter.getOneDimensionalDataSource(source: data)
    }
    
}
