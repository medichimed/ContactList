//
//  EditPageUITests.swift
//  task9UITests
//
//  Created by Oksana Kotilevska on 1/23/20.
//  Copyright © 2020 Oksana Kotilevska. All rights reserved.
//

import XCTest


class EditPageUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUp() {
        app = XCUIApplication()
        app.launchArguments += ["enable-testingEditPage"]
        
        app.launch()

    }

    override func tearDown() {
        app = nil
    }
    
    func test_PressAddBtn_EnterContactDetailsWithPhoto_PressAdd_CheckForSuccess() {

        app.navigationBars["task9.ContactsListTableView"].buttons["Item"].tap()
        app.textFields["firstNameEdit"].tap()
        app.textFields["firstNameEdit"].typeText("Edgar Allan")
        app.buttons["Return"].tap()
        
        app.textFields["secondNameEdit"].tap()
        app.textFields["secondNameEdit"].typeText("Poe")
        app.buttons["Return"].tap()
        
        app.textFields["phoneEdit"].tap()
        app.textFields["phoneEdit"].typeText("+380778577822")
        app.buttons["Return"].tap()
        
        app.textFields["emailEdit"].tap()
        app.textFields["emailEdit"].typeText("crow@mistery.ua")

        app.navigationBars["New Contact"].buttons["Add"].tap()
        
        XCTAssertTrue(app.tables.staticTexts["Edgar Allan Poe"].exists)
    }

    func test_PressAddBtn_EnterNameAndClickOnPhoto_CheckIfGalleryOptionAppears() {

        app.navigationBars["task9.ContactsListTableView"].buttons["Item"].tap()
        app.textFields["First Name"].tap()
        app.textFields["First Name"].typeText("Eva")
        
        app.buttons["Return"].tap()

        app.images["avatarEdit"].tap()

        XCTAssertTrue(app.sheets.scrollViews.otherElements.buttons["Gallery"].exists)

    }
    
    func test_PressOnExistingContact_CheckDetailsPage_SuccessIfDetailsAreCorrect_PressEdit_EnterPhone_PressSave_CheckDetailsIfChanged() {
        
        let desiredPhone = "+380999912657"
        let desiredFirstName = "Hunter Stockton"
        let desiredSecondName = "Thompson"
        let desiredEmail = "GenerationOfSwine@mail.ru"
        
        app.tables.staticTexts["Hunter Stockton Thompson"].tap()

        //Details check
        XCTAssertTrue(app.navigationBars["Hunter Stockton Thompson"].exists)
        
        XCTAssertEqual(app.staticTexts.element(matching:.any, identifier: "firstNameDetails").label, desiredFirstName)
        XCTAssertEqual(app.staticTexts.element(matching:.any, identifier: "secondNameDetails").label, desiredSecondName)
        XCTAssertEqual(app.staticTexts.element(matching:.any, identifier: "emailDetails").label ,desiredEmail)

        XCTAssertTrue(app.staticTexts.element(matching: .any, identifier: "phoneDetails").label.isEmpty)
        
        //Editing check
        app.navigationBars["Hunter Stockton Thompson"].buttons["Edit"].tap()

        app.textFields["phoneEdit"].tap()
        app.textFields["phoneEdit"].typeText("+380999912657")
        app.buttons["Return"].tap()
        
        XCTAssertTrue(app.navigationBars["Hunter Stockton Thompson"].buttons["Save"].exists)
        
        app.navigationBars["Hunter Stockton Thompson"].buttons["Save"].tap()
        
        XCTAssertEqual(app.staticTexts.element(matching: .any, identifier: "phoneDetails").label, desiredPhone)

    }
    
    func test_PressOnExistingContact_CheckDetailsPage_PressEdit_CheckTextFieldsToBeFilledIfNeeded_PressDelete_SuccessIfContactDeleted() {

        let desiredFirstName = "Joseph"
        let desiredSecondName = "Heller"
        let desiredEmail = "catch-22@mail.ru"
        
        app.tables.staticTexts["Joseph Heller"].tap()
        
        //Details check
        XCTAssertTrue(app.navigationBars["Joseph Heller"].exists)
        XCTAssertEqual(app.staticTexts.element(matching: .staticText , identifier: "firstNameDetails").label, desiredFirstName)
        XCTAssertEqual(app.staticTexts.element(matching: .staticText , identifier: "secondNameDetails").label, desiredSecondName)
        XCTAssertEqual(app.staticTexts.element(matching: .staticText, identifier: "emailDetails").label, desiredEmail)
        XCTAssertTrue(app.staticTexts.element(matching: .staticText, identifier: "phoneDetails").label.isEmpty)
        
        app.navigationBars["Joseph Heller"].buttons["Edit"].tap()
        
        //Edit page delition
        app.buttons["Delete Contact"].tap()
        app.sheets.scrollViews.otherElements.buttons["Delete"].tap()
        
        XCTAssertFalse(app.tables.staticTexts["Joseph Heller"].exists)
    }
    
    

}
