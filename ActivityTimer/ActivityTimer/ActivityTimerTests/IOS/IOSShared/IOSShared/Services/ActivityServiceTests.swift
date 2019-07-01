//
//  ActivityServiceTests.swift
//  ActivityTimerTests
//
//  Created by Krzysztof Maraszkiewicz on 21/06/2019.
//  Copyright © 2019 Krzysztof Maraszkiewicz. All rights reserved.
//

import XCTest
class ActivityServiceTests: XCTestCase {

    ///The subject under test
    var sut: ActivityService!
    
    ///The mock version of NSManagedObjectContext class
    var managedObjectContextMock: NSManagedObjectContextMock!
    
    ///Set up required data
    override func setUp() {
        
    }

    
    /// Test scenario check if getAll method return proper values from db
    ///
    /// - Throws: unit test error
    func test_getAll_databaseNotEmpty_ShouldReturnNotNullData() throws {
        
        managedObjectContextMock = (CoreDataFakeManager.setupInMemoryManagedObjectContext([ActivityModel(name: "test1"),
                                                                                           ActivityModel(name: "test2"),
                                                                                           ActivityModel(name: "test3")]) as! NSManagedObjectContextMock)
        sut = ActivityService.shared(managedObjectContextMock)
        
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
    
    /// <#Description#>
    ///
    /// - Throws: <#throws value description#>
    func test_getAll_databaseEmpty_ShouldReturnEmptyData() throws {
        managedObjectContextMock = (CoreDataFakeManager.setupInMemoryManagedObjectContext([]) as! NSManagedObjectContextMock)
        sut = ActivityService.shared(managedObjectContextMock)
        
        do {
            let activitiesFromDatabase = try sut.getAll()
            
            XCTAssertEqual(activitiesFromDatabase.count, 0)
            
        } catch {
            throw ActivityTimerTestsError.unitTestError
        }
    }
    
    func test_getAll_databaseThrowException_ShouldReturnNotNullData() throws {
        
        managedObjectContextMock = (CoreDataFakeManager.setupInMemoryManagedObjectContext([ActivityModel(name: "test1")]) as! NSManagedObjectContextMock)
        sut = ActivityService.shared(managedObjectContextMock)
        
        do {
            try sut.getAll()
            
            throw ActivityTimerTestsError.unitTestError
            
        } catch {
            
        }
    }
    
    //Clean data after each test
    override func tearDown() {
        managedObjectContextMock.activities = nil
        managedObjectContextMock.activityIndex = 0
        managedObjectContextMock = nil
        sut = nil
    }
}
