//
//  NSManagedObjectTests.swift
//  ActivityTimerTests
//
//  Created by Krzysztof Maraszkiewicz on 20/06/2019.
//  Copyright © 2019 Krzysztof Maraszkiewicz. All rights reserved.
//

import CoreData
import XCTest

///Unit tests of NSManagedObject extension
class NSManagedObjectTests: XCTestCase {

    ///Helper class, that create mock version of Core Data base classes
    var coreDataManager: CoreDataManger!
    
    ///Set up required data
    override func setUp() {
        super.setUp()
        
        coreDataManager = CoreDataManger()
    }
    
    //Clean data after each test
    override func tearDown() {
        super.tearDown()
        coreDataManager = nil
    }

    
    /// test toactivityModel method with valid data should return valid data
    func test_toActivityModel_shouldGenerateValidModel () {
        
        //Given
        let activity = ActivityModel(name: "test1")
        
        //When
        let activityManagedObject = generateNsManagedObject(acivity: activity)
        let activityFromModel = activityManagedObject.toActivityModel()
        
        //Then
        XCTAssertEqual(activity.id, activityFromModel.id)
        XCTAssertEqual(activity.name, activityFromModel.name)
    }
    
    //MARK: helper methods
    
    /// Generate required objects for creating NSManagedObject object
    ///
    /// - Parameter acivity: The ActivityModel object
    /// - Returns: NSManagedObject object
    private func generateNsManagedObject(acivity: ActivityModel) -> NSManagedObject {
        
        let context = self.coreDataManager.mainContext
        let description = NSEntityDescription.entity(forEntityName: "Activity", in: context)
        
        let managedObject = NSManagedObject(entity: description!, insertInto: context)
        
        managedObject.setValue(acivity.name, forKey: "name")
        acivity.id = managedObject.objectID.uriRepresentation()
        
        return managedObject
        
    }

}
