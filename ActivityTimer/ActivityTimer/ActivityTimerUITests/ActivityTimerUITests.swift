//
//  ActivityTimerUITests.swift
//  ActivityTimerUITests
//
//  Created by Krzysztof Maraszkiewicz on 23/05/2019.
//  Copyright © 2019 Krzysztof Maraszkiewicz. All rights reserved.
//

import XCTest

class ActivityTimerUITests: XCTestCase {

    private let uuid = NSUUID().uuidString
    
    private var app: XCUIApplication!
    
    private var tablesQuery: XCUIElementQuery  {
        return self.app.tables
    }
    
    private var activityTableView: XCUIElement {
        return app.navigationBars["ActivityTimer.ActivityTableView"]
    }
    
    private var activityFormView: XCUIElement {
        return app.navigationBars["ActivityTimer.ActivityFormView"]
    }
    
    private var addButton: XCUIElement {
        return self.activityTableView.buttons["Add"]
    }
    
    private var editButton: XCUIElement {
        return self.activityTableView.buttons["Edit"]
    }
    
    private var saveButton: XCUIElement {
        return self.activityFormView.buttons["Save"]
    }
    
    private var addTextField: XCUIElement {
        return app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .textField).element
    }
    
    
    
    private var editTextField: XCUIElement {
        return app.otherElements.containing(.navigationBar, identifier:"ActivityTimer.ActivityFormView").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .textField).element
    }
    
    override func setUp() {
        continueAfterFailure = false
        
        self.app = XCUIApplication()
        self.app.launch()
    }

    override func tearDown() {
        self.app = nil
    }

    private func fillActivityForm (suffix: String? = nil) {
        
        var textField = self.addTextField
        var value = self.uuid
        
        if let val = suffix {
            textField = self.editTextField
            value = " \(val)"
        }
        
        textField.tap()
        textField.typeText("\(value)")
        pressReturnOnKeyboard()

        self.saveButton.tap()
    }
    
    private func deleteActivity(id: String) {
        self.editButton.tap()
        
        self.tablesQuery.buttons["Delete \(id)"].tap()
        self.tablesQuery.buttons["Delete"].tap()
    }
    
    private func pressReturnOnKeyboard() {
        //simulate press return key on textfield
        let firstKey = app.keys.element(boundBy: 0)
        if firstKey.exists {
            app.typeText("\n")
        }
    }
    
    private func isTableContainElement(_ text: String) -> Bool {
        return self.tablesQuery.containing(XCUIElement.ElementType.staticText, identifier: text).count > 0
    }
    
    func test_addingActivityItem() {
        self.addButton.tap()
        
        fillActivityForm()
        
        XCTAssertTrue(isTableContainElement("\(self.uuid)"))

        deleteActivity(id: uuid)
        
        XCTAssertFalse(isTableContainElement("\(self.uuid)"))
    }
    
    func test_editActivityItem() {
        self.addButton.tap()
        
        fillActivityForm()
        
        XCTAssertTrue(isTableContainElement("\(self.uuid)"))
        
        self.tablesQuery.staticTexts["\(self.uuid)"].tap()
        
        fillActivityForm(suffix: "1")
        
        XCTAssertFalse(isTableContainElement("\(self.uuid)"))
        XCTAssertTrue(isTableContainElement("\(self.uuid) 1"))
        
        deleteActivity(id: "\(self.uuid) 1")
        
        XCTAssertFalse(isTableContainElement("\(self.uuid) 1"))
    }
}
