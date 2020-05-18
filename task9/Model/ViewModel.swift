//
//  ViewModel.swift
//  task9
//
//  Created by Oksana Kotilevska on 2/3/20.
//  Copyright © 2020 Oksana Kotilevska. All rights reserved.
//

import UIKit

class ViewModel {
    private let key = "contactStorage"
    weak var delegate: ViewModelDelegate!
    var twoDimensionalDataSource = [StoredData]()
    private var searchText: String?
    var filteredContacts = [ContactModel]()
    
    func getNumberOfSections() -> Int {
        
        if delegate.isFiltering || twoDimensionalDataSource.count == 0{
            return 1
        }
        
        return twoDimensionalDataSource.count
    }

    func getHeader(section: Int) -> String?{

        if delegate.isFiltering{
            return nil
        }
        if twoDimensionalDataSource.count == 0{
            return nil
        }
        return twoDimensionalDataSource[section].header
    }
    
    func getNumberOfRowsInSection(section: Int) -> Int{

        if delegate.isFiltering{
            return filteredContacts.count
        }
        if twoDimensionalDataSource.count == 0{
            return 0
        }
        return twoDimensionalDataSource[section].contacts.count
    }
    
    func getAttributedText(forRowAt indexPath: IndexPath) -> NSAttributedString {
        if delegate.isFiltering{
            return updateResults(baseString: filteredContacts[indexPath.row].displayName)!
        }
        
        return NSAttributedString(string: twoDimensionalDataSource[indexPath.section].contacts[indexPath.row].displayName)
    }
    
    func getImage(forRowAt indexPath: IndexPath) -> UIImage? {
        if delegate.isFiltering{
           return filteredContacts[indexPath.row].image
        }
        return twoDimensionalDataSource[indexPath.section].contacts[indexPath.row].image
    }
    
    func getId(indexPath: IndexPath) -> String {
        
        if delegate.isFiltering{
            return filteredContacts[indexPath.row].contactId!
        }
        return twoDimensionalDataSource[indexPath.section].contacts[indexPath.row].contactId!
    }
    
    func alphabethSet() -> [String]? {
        let letters = twoDimensionalDataSource.map { (item) -> String in
            return item.header!
        }
        return letters
    }
    
    func updateDataSource(){

        let dataSource = StorageService.getStoredData().map { (contact) -> ContactModel in
            let contact = ContactModel(contactDictionary: contact)
            return contact
        }
        
        twoDimensionalDataSource = StorageService.convertSourceIntoTwoDimensions(from: dataSource)
    }
    
    func update(searchText: String?) {
        self.searchText = searchText
        filterList(searchText)
        delegate?.viewModelDidUpdateFiltering(self)
    }
    
    private func filterList(_ searchText: String?) {
            
        let oneDimensionalSource = StorageService.convertSourceIntoOneDimension(from: twoDimensionalDataSource)
        guard let text = searchText else { return }
        
           filteredContacts = oneDimensionalSource.filter({(contact: ContactModel) -> Bool in
            return contact.displayName.lowercased().contains(text.lowercased())
           })
    }
    
    func updateResults(baseString: String) -> NSMutableAttributedString?{

        let str: NSString = baseString as NSString

        guard let target = searchText else { return nil }
        let loweredRange = target.lowercased()
        let loweredStr = str.lowercased as NSString
        
        let matchRange: NSRange = (loweredStr).range(of: loweredRange)
        
        let fullRange = (str).range(of: str as String)

        let attr = NSMutableAttributedString.init(string: str as String)
        attr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.gray, range: fullRange)
        attr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: matchRange)
        
        return attr
    }

    func getContact(by contactId: String) -> ContactModel? {

       let contactToBePassed =  StorageService.getStoredData().filter { (item) -> Bool in
            return item["contactId"] as? String == contactId
        }
        
        if let contact = contactToBePassed.first {
            return ContactModel(contactDictionary: contact)
        }
        
        return nil
    }

}
