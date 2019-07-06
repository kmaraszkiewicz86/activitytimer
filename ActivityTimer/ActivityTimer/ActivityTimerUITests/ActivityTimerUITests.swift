//
//  ActivityTimerUITests.swift
//  ActivityTimerUITests
//
//  Created by Krzysztof Maraszkiewicz on 23/05/2019.
//  Copyright © 2019 Krzysztof Maraszkiewicz. All rights reserved.
//

import XCTest

///The ActivityTimer UI Tests
class ActivityTimerUITests: XCTestCase {

    //MARK: private properties
    ///Unique name for activity name
    private let uuid = NSUUID().uuidString
    
    //MARK: UI elements
    ///Application main service
    private var app: XCUIApplication!
    
    ///The activity table elememnt
    private var tablesQuery: XCUIElementQuery  {
        return self.app.tables
    }
    
    ///The activity items list view
    private var activityTableView: XCUIElement {
        return app.navigationBars["ActivityTimer.ActivityTableView"]
    }
    
    ///The activity form
    private var activityFormView: XCUIElement {
        return app.navigationBars["ActivityTimer.ActivityFormView"]
    }
    
    ///The add button that go to activity add form view
    private var addButton: XCUIElement {
        return self.activityTableView.buttons["Add"]
    }
    
    ///The edit button on activity list view to enable delete items
    private var editButton: XCUIElement {
        return self.activityTableView.buttons["Edit"]
    }
    
    ///The save button on Activity form view that save activity item
    private var saveButton: XCUIElement {
        return self.activityFormView.buttons["Save"]
    }
    
    ///Add activity text field on Activity add form view
    private var addTextField: XCUIElement {
        return app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .textField).element
    }
    
    ///Edit activity text field on Activity edit form view
    private var editTextField: XCUIElement {
        return app.otherElements.containing(.navigationBar, identifier:"ActivityTimer.ActivityFormView").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .textField).element
    }
    
    ///Set up properties for testing
    override func setUp() {
        continueAfterFailure = false
        
        self.app = XCUIApplication()
        self.app.launch()
    }

    ///Dispose alll elemnets after running test
    override func tearDown() {
        self.app = nil
    }

    
    /// Fills activity form
    ///
    /// - Parameter suffix: The suffix, that will be add when test want to edit activity element
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
    
    
    /// Deletes activity
    ///
    /// - Parameter id: id string reference to activity to delete
    private func deleteActivity(id: String) {
        self.editButton.tap()
        
        self.tablesQuery.buttons["Delete \(id)"].tap()
        self.tablesQuery.buttons["Delete"].tap()
    }
    
    
    /// Simulate press return key on keyboard by user
    private func pressReturnOnKeyboard() {
        //simulate press return key on textfield
        let firstKey = app.keys.element(boundBy: 0)
        if firstKey.exists {
            app.typeText("\n")
        }
    }
    
    ///Check if activity item by text exists on activity list view
    private func isTableContainElement(_ text: String) -> Bool {
        return self.tablesQuery.containing(XCUIElement.ElementType.staticText, identifier: text).count > 0
    }
    
    ///Test for adding Activity item
    func test_addingActivityItem() {
        self.addButton.tap()
        
        fillActivityForm()
        
        XCTAssertTrue(isTableContainElement("\(self.uuid)"))

        deleteActivity(id: uuid)
        
        XCTAssertFalse(isTableContainElement("\(self.uuid)"))
    }
    
    ///Test for edit activity item
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
