//
//  ActivityTimerUITests.swift
//  ActivityTimerUITests
//
//  Created by Krzysztof Maraszkiewicz on 23/05/2019.
//  Copyright © 2019 Krzysztof Maraszkiewicz. All rights reserved.
//

import XCTest

class ActivityTimerUITests: XCTestCase {

    private var app: XCUIApplication!
    
    override func setUp() {
        self.app = XCUIApplication()
        
        continueAfterFailure = false

        XCUIApplication().launch()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_addingActivityItem() {
        
        let activitytimerActivitytableviewNavigationBar = app.navigationBars["ActivityTimer.ActivityTableView"]
        activitytimerActivitytableviewNavigationBar.buttons["Add"].tap()
        
        let textField = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .textField).element
        textField.tap()
        textField.typeText("testowe słowo   ")
        textField.tap()
        
        print(textField.staticTexts.accessibilityElement(at: 0))
        
//        app.navigationBars["ActivityTimer.ActivityFormView"].buttons["Save"].tap()
//        activitytimerActivitytableviewNavigationBar.buttons["Edit"].tap()
//
//        let tablesQuery = app.tables
//
//        XCTAssertNotNil(tablesQuery.buttons["testowe słowo"])
//
//        tablesQuery.buttons["testowe słowo"].tap()
//        tablesQuery.buttons["Delete"].tap()
//
//        XCTAssertNil(tablesQuery.buttons["testowe słowo"])
    }
    
    func test_editActivityItem() {
        
        let activitytimerActivitytableviewNavigationBar = app.navigationBars["ActivityTimer.ActivityTableView"]
        activitytimerActivitytableviewNavigationBar.buttons["Add"].tap()
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .textField).element.tap()
        
        let saveButton = app.navigationBars["ActivityTimer.ActivityFormView"].buttons["Save"]
        saveButton.tap()
        
        let tablesQuery2 = app.tables
        let tablesQuery = tablesQuery2
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["testowanie"]/*[[".cells.staticTexts[\"testowanie\"]",".staticTexts[\"testowanie\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.otherElements.containing(.navigationBar, identifier:"ActivityTimer.ActivityFormView").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .textField).element.tap()
        saveButton.tap()
        activitytimerActivitytableviewNavigationBar.buttons["Edit"].tap()
        tablesQuery/*@START_MENU_TOKEN@*/.buttons["Delete testowanie 123"]/*[[".cells.buttons[\"Delete testowanie 123\"]",".buttons[\"Delete testowanie 123\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery2.buttons["Delete"].tap()
        
        
    }
    
    func test_deleteActivityItem() {
        
        let activitytimerActivitytableviewNavigationBar = app.navigationBars["ActivityTimer.ActivityTableView"]
        activitytimerActivitytableviewNavigationBar.buttons["Add"].tap()
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .textField).element.tap()
        app.navigationBars["ActivityTimer.ActivityFormView"].buttons["Save"].tap()
        
        let editButton = activitytimerActivitytableviewNavigationBar.buttons["Edit"]
        editButton.tap()
        editButton.tap()
        
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.buttons["Delete testowanie"]/*[[".cells.buttons[\"Delete testowanie\"]",".buttons[\"Delete testowanie\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery.buttons["Delete"].tap()
        
    }

}
