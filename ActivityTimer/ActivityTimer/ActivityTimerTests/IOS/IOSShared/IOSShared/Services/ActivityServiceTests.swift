//
//  ActivityServiceTests.swift
//  ActivityTimerTests
//
//  Created by Krzysztof Maraszkiewicz on 21/06/2019.
//  Copyright © 2019 Krzysztof Maraszkiewicz. All rights reserved.
//

import XCTest
@testable import IOSShared

class ActivityServiceTests: XCTestCase {

    ///The subject under test
    var sut: ActivityService!
    
    ///The mock version of NSManagedObjectContext class
    var managedObjectContextMock: NSManagedObjectContextMock!
    
    ///Set up required data
    override func setUp() {
        managedObjectContextMock = NSManagedObjectContextMock()
        sut = ActivityService.shared(managedObjectContextMock!.coreDataManager.mainContext)
    }

    
    /// Test scenario check if getAll method return proper values from db
    ///
    /// - Throws: unit test error
    func test_getAll_databaseNotEmpty_ReturnNotNullData() throws {
        
        managedObjectContextMock.activities = [ActivityModel(name: "test1"),
                                               ActivityModel(name: "test2"),
                                               ActivityModel(name: "test3")]
        do {
            let activitiesFromDatabase = try sut.getAll()
            
            XCTAssertEqual(managedObjectContextMock.activities!.count, activitiesFromDatabase.count)
            
            for index in 0..<managedObjectContextMock.activities!.count {
                XCTAssertEqual(managedObjectContextMock.activities![index].name, activitiesFromDatabase[index].name)
            }
            
            
        } catch {
            throw ActivityTimerTestsError.unitTestError
        }
    }
    
    //Clean data after each test
    override func tearDown() {
        managedObjectContextMock = nil
        sut = nil
    }
}
