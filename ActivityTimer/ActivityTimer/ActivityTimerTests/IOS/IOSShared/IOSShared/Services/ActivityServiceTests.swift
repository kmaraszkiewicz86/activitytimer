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
        NSManagedObjectContextMock.shouldThrowOnFetch = true
        
        do {
            let _ = try sut.getAll()
            
        } catch ServiceError.databaseError {
            return
        }
        
        //then
        throw ActivityTimerTestsError.unitTestError
    }
    
    
    /// Test save method should save data in database with success
    func test_save_shouldSaveItemInDatabase() throws {
        
        NSManagedObjectContextMock.activities = [ActivityModel(id: URL(string: "test1"), name: "test1"),                                                          ActivityModel(id: URL(string: "test2"), name: "test2"), ActivityModel(id: URL(string: "test3"), name: "test3")]
        
        do {
            //given
            let activity = ActivityModel(id: URL(string: "test1"), name: "test")
            //when
            let activityFromDB = try sut.save(activityModel: activity)
            
            XCTAssertEqual(activity.id, activityFromDB.id)
            XCTAssertEqual(activity.name, activityFromDB.name)
            
        } catch {
            //then
            throw ActivityTimerTestsError.error
        }
    }
    
    /// Test save method when action throws error
    func test_save_shouldThrowsError() throws {
        
        NSManagedObjectContextMock.activities = [ActivityModel(id: URL(string: "test1"), name: "test1"),                                                          ActivityModel(id: URL(string: "test2"), name: "test2"), ActivityModel(id: URL(string: "test3"), name: "test3")]
        
        NSManagedObjectContextMock.shouldThrowOnSave = true
        
        do {
            //given
            let activity = ActivityModel(name: "test")
            //when
            let _ = try sut.save(activityModel: activity)
            
        } catch ServiceError.databaseError {
            //test passed
            return
        }
        
        //then
        //test failed
        throw ActivityTimerTestsError.error
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
    
    /// Test update method when no item found should throws error
    func test_update_whenNoItemFound_shouldThrowsError() throws {
        
        NSManagedObjectContextMock.activities = [ActivityModel(id: URL(string: "test1"), name: "test1")]
        
        NSManagedObjectContextMock.activityIndex = 0
        NSManagedObjectContextMock.shouldFoundNoItem = true
        
        do {
            //given
            let activity = ActivityModel(name: "test")
            //when
            try sut.update(id: URL(string: "test1"), activityModel: activity)
            
        } catch ServiceError.databaseError {
            //test passed
            return
        }
        
        //then
        //test failed
        throw ActivityTimerTestsError.error
    }
    
    //Clean data after each test
    override func tearDown() {
        NSManagedObjectContextMock.activities = nil
        NSManagedObjectContextMock.activityIndex = 0
        NSManagedObjectContextMock.shouldThrowOnSave = false
        NSManagedObjectContextMock.shouldThrowOnFetch = false
        NSManagedObjectContextMock.shouldFoundNoItem = false
        managedObjectContextMock = nil
        sut = nil
        
    }
}
