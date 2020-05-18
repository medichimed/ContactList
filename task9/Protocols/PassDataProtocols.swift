//
//  PassDataProtocol.swift
//  task9
//
//  Created by Oksana Kotilevska on 1/10/20.
//  Copyright © 2020 Oksana Kotilevska. All rights reserved.
//

import Foundation

protocol PassData: class{
    func passContactDetails(newContact: ContactModel)
    func deleteContact(deletedContact: ContactModel)
}
