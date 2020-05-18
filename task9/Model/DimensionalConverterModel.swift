//
//  DimensionalConverterModel.swift
//  task9
//
//  Created by Oksana Kotilevska on 1/29/20.
//  Copyright © 2020 Oksana Kotilevska. All rights reserved.
//

import Foundation

struct DimensionalConverter{
    private static let key = "contactStorage"
    
    static func getTwoDimensionalDataSource(source: [ContactModel]) -> [StoredData]? {
        
        let orderedArray = source.sorted(by: < )
        
        var dataSourceIndex = 0
        var  twoDimensionalDataSource = [StoredData]()
        
        let storageOfOtherContacts = StoredData()
        storageOfOtherContacts.header = "#"
        
        
        while dataSourceIndex != orderedArray.count {
            let letter = orderedArray[dataSourceIndex].displayName.first?.lowercased()
            
            if !(letter!.isLetter){
                storageOfOtherContacts.contacts.append(orderedArray[dataSourceIndex])
                dataSourceIndex += 1
                continue
            }
            
            let contactsHolder = orderedArray.filter { (contactItem) -> Bool in
                let firstLetter = String(contactItem.displayName.lowercased().first!)
                return firstLetter == letter
            }
            
            dataSourceIndex = contactsHolder.count + dataSourceIndex
            
            let newContactsSet = StoredData()
            
            newContactsSet.header = letter?.uppercased()
            newContactsSet.contacts = contactsHolder
            
            twoDimensionalDataSource.append(newContactsSet)
        }
        
        if !storageOfOtherContacts.contacts.isEmpty{
            twoDimensionalDataSource.append(storageOfOtherContacts)
        }
        
        return twoDimensionalDataSource
        
    }
    
    static func getOneDimensionalDataSource(source: [StoredData]) -> [ContactModel]{
        
        let result = source.reduce([ContactModel]()){$0 + $1.contacts}
        return result

    }

    static func setUserDefaults(dictionary: [[String: Any]]){
        UserDefaults.standard.set(dictionary, forKey: key)
    }

}

extension String {
    var isLetter: Bool {
        let letterRegEx = "[a-я]"
        
        let letterPred = NSPredicate(format:"SELF MATCHES %@", letterRegEx)
        return letterPred.evaluate(with: self)
    }
}
