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
import IOSShared

class NSManagedObjectArrayExtensionTests: XCTestCase {

    var coreDataManager: CoreDataManger!
    
    override func setUp() {
        super.setUp()
        
        coreDataManager = CoreDataManger()
    }

    override func tearDown() {
        coreDataManager = nil
    }
    
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
    
    private func generateNSManagedObjects(_ activities: [ActivityModel]) -> [NSManagedObject] {
        
        return activities.map({ (activityModel) -> NSManagedObject in
            
            let description = NSEntityDescription.entity(forEntityName: "Activity", in: self.coreDataManager.mainContext)
            let managdObject = NSManagedObject(entity: description!, insertInto: self.coreDataManager.mainContext)
            
            managdObject.setValue(activityModel.name, forKey: "name")
            activityModel.id = managdObject.objectID.uriRepresentation()

            return managdObject
        })
    }
}
