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
        
        managedObjectContextMock = CoreDataFakeManager.setupInMemoryManagedObjectContext()
        sut = ActivityService.shared(managedObjectContextMock)
    }

    
    /// Test scenario check if getAll method return proper values from db
    ///
    /// - Throws: unit test error
    func test_getAll_databaseNotEmpty_ShouldReturnNotNullData() throws {
        
        NSManagedObjectContextMock.activities = [ActivityModel(name: "test1"),                                                          ActivityModel(name: "test2"), ActivityModel(name: "test3")]
        
        do {
            let activitiesFromDatabase = try sut.getAll()
            
            XCTAssertEqual(NSManagedObjectContextMock.activities!.count, activitiesFromDatabase.count)
            
            for index in 0..<NSManagedObjectContextMock.activities!.count {
                XCTAssertEqual(NSManagedObjectContextMock.activities![index].name, activitiesFromDatabase[index].name)
            }
            
            
        } catch {
            throw ActivityTimerTestsError.unitTestError
        }
    }
    
    /// test get all when database is empty
    ///
    /// - Throws: throws when getAll method throw error
    func test_getAll_databaseEmpty_ShouldReturnEmptyData() throws {
        NSManagedObjectContextMock.activities = []
        
        do {
            let activitiesFromDatabase = try sut.getAll()
            
            XCTAssertEqual(activitiesFromDatabase.count, 0)
            
        } catch {
            throw ActivityTimerTestsError.unitTestError
        }
    }
    
    
    /// test getAll method when database throw error
    ///
    /// - Throws: throws when tests doesnt detect that getAll method throws error
    func test_getAll_databaseThrowException_ShouldReturnNotNullData() throws {
        
        NSManagedObjectContextMock.activities = []
        NSManagedObjectContextMock.shouldThrowOnSave = true
        
        do {
            let _ = try sut.getAll()
            
            throw ActivityTimerTestsError.unitTestError
            
        } catch {
            
        }
    }
    
    
    /// Test update method should save data in database with success
    func test_update_shouldSaveItemInDatabase() throws {
        
        NSManagedObjectContextMock.activities = [ActivityModel(id: URL(string: "test1"), name: "test1"),                                                          ActivityModel(id: URL(string: "test2"), name: "test2"), ActivityModel(id: URL(string: "test3"), name: "test3")]
        
        NSManagedObjectContextMock.activityIndex = 0
        
        do {
            //given
            let activity = ActivityModel(name: "test")
            //when
            try sut.update(id: URL(string: "test1"), activityModel: activity)
            
        } catch {
            //then
            throw ActivityTimerTestsError.error
        }
    }
    
    //Clean data after each test
    override func tearDown() {
        NSManagedObjectContextMock.activities = nil
        NSManagedObjectContextMock.activityIndex = 0
        managedObjectContextMock = nil
        sut = nil
        
    }
}
