//
//  NSManagedObjectTests.swift
//  ActivityTimerTests
//
//  Created by Krzysztof Maraszkiewicz on 20/06/2019.
//  Copyright © 2019 Krzysztof Maraszkiewicz. All rights reserved.
//

import CoreData
import XCTest
import IOSShared

class NSManagedObjectTests: XCTestCase {

    var coreDataManager: CoreDataManger!
    
    override func setUp() {
        super.setUp()
        
        coreDataManager = CoreDataManger()
    }
    
    override func tearDown() {
        super.tearDown()
        coreDataManager = nil
    }

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
    
    private func generateNsManagedObject(acivity: ActivityModel) -> NSManagedObject {
        
        let context = self.coreDataManager.mainContext
        let description = NSEntityDescription.entity(forEntityName: "Activity", in: context)
        
        let managedObject = NSManagedObject(entity: description!, insertInto: context)
        
        managedObject.setValue(acivity.name, forKey: "name")
        acivity.id = managedObject.objectID.uriRepresentation()
        
        return managedObject
        
    }

}
