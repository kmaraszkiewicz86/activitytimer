//
//  NSManagedObjectArrayExtensionTests.swift
//  ActivityTimerTests
//
//  Created by Krzysztof Maraszkiewicz on 20/06/2019.
//  Copyright © 2019 Krzysztof Maraszkiewicz. All rights reserved.
//

import UIKit
import CoreData
import XCTest

///Unit tests for ios version of NSManagedObject array
class NSManagedObjectArrayExtensionTests: XCTestCase {

    ///Helper class, that create mock version of Core Data base classes
    var context: NSManagedObjectContextMock!
    
    ///Set up required data
    override func setUp() {
        super.setUp()
        
        context = (CoreDataFakeManager.setupInMemoryManagedObjectContext() as! NSManagedObjectContextMock)
    }

    ///Clean data after each test
    override func tearDown() {
        context = nil
    }
    
    ///Test valid version of data of toActivityModel method
    func test_toActivitiesModel_whenDataIsValid_ShouldreturnValidActivityItemss() {
        
        let activities: [ActivityModel] = [ActivityModel(name: "test1"), ActivityModel(name: "test2"), ActivityModel(name: "test3")]
        
        //Given
        let activitiesNSManagedObjects = generateNSManagedObjects(activities)
        
        //When
        let activitiesFromModel = activitiesNSManagedObjects.toActivityModel()
        
        //Then
        XCTAssertEqual(activities.count, activitiesFromModel.count)
        
        for index in 0..<activities.count {
            
            XCTAssertEqual(activities[index].id, activitiesFromModel[index].id)
            
            XCTAssertEqual(activities[index].name, activitiesFromModel[index].name)
            
        }
    }
    
    //MARK: helpers methods
    ///Generate required objects for creating NSManagedObject object
    ///
    /// - Parameter activities: ActivityModel array that will be convert to NSManagedObject array
    /// - Returns: NSManagedobject array
    private func generateNSManagedObjects(_ activities: [ActivityModel]) -> [NSManagedObject] {
        
        return activities.map({ (activityModel) -> NSManagedObject in
            
            let description = NSEntityDescription.entity(forEntityName: "Activity", in: self.context.context)
            let managdObject = NSManagedObject(entity: description!, insertInto: self.context.context)
            
            managdObject.setValue(activityModel.name, forKey: "name")
            activityModel.id = managdObject.objectID.uriRepresentation()

            return managdObject
        })
    }
}
