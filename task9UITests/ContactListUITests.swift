//
//  task9UITests.swift
//  task9UITests
//
//  Created by Oksana Kotilevska on 1/22/20.
//  Copyright © 2020 Oksana Kotilevska. All rights reserved.
//

import XCTest

class ContactListUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUp() {
        app = XCUIApplication()
        app.launchArguments += ["enable-testing"]
        app.launch()
    }
    
    override func tearDown() {
        app = nil

    }

 
    func test_PressAddButton_CreateContact_PressAdd() {

            app.tables["Your contact list is empty for now"].buttons["Add Contact"].tap()
            
            app.textFields["firstNameEdit"].tap()
            app.textFields["firstNameEdit"].typeText("Jane")
            app.buttons["Return"].tap()

            app.textFields["secondNameEdit"].tap()
            app.textFields["secondNameEdit"].typeText("Doe")

            app.navigationBars["New Contact"].buttons["Add"].tap()
            
            XCTAssertTrue(app.tables.staticTexts["Jane Doe"].exists)
    }
    
    func test_CheckIfAnyExcessButtonsArePresent() {

        let navBar = app.navigationBars["task9.ContactsListTableView"]
        XCTAssertFalse(navBar.buttons["Edit"].exists)
        XCTAssertFalse(navBar.buttons["Item"].exists)

    }
    
    func test_PressAddButton_EnterInvalidPhone_CheckIfPageDissmisses() {
        
        app.tables["Your contact list is empty for now"].buttons["Add Contact"].tap()
        app.textFields["phoneEdit"].tap()
        app.textFields["phoneEdit"].typeText("WTF")
        app.navigationBars.buttons["Add"].tap()
        XCTAssertTrue(app.navigationBars["New Contact"].exists)

    }
    
    func test_PressAddButton_EnterData_PressAdd_CheckIfNavigationBarHasChanged() {

        app.tables["Your contact list is empty for now"].buttons["Add Contact"].tap()
        
        app.textFields["secondNameEdit"].tap()
        app.textFields["secondNameEdit"].typeText("Clinton")
        
        XCTAssertTrue(app.navigationBars["New Contact"].exists)
        
        app.navigationBars["New Contact"].buttons["Add"].tap()
        
        XCTAssertTrue(app.navigationBars["task9.ContactsListTableView"].buttons["Edit"].exists)
        XCTAssertTrue(app.navigationBars["task9.ContactsListTableView"].buttons["Item"].exists)
                
    }
    

}
