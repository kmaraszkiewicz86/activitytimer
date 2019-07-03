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
        
        managedObjectContextMock.activities = [ActivityModel(id: URL(string: "test1"), name: "test1"),                                                          ActivityModel(id: URL(string: "test2"), name: "test2"), ActivityModel(id: URL(string: "test3"), name: "test3")]
        
        sut = ActivityService.shared(managedObjectContextMock)
    }

    
    /// Test scenario check if getAll method return proper values from db
    ///
    /// - Throws: unit test error
    func test_getAll_databaseNotEmpty_ShouldReturnNotNullData() throws {
        
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
    
    /// test get all when database is empty
    ///
    /// - Throws: throws when getAll method throw error
    func test_getAll_databaseEmpty_ShouldReturnEmptyData() throws {
        managedObjectContextMock.activities = []
        
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
    func test_getAll_WhenDatabaseThrowException() throws {
        
        managedObjectContextMock.shouldThrowOnFetch = true
        
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
        
        do {
            //given
            let activity = ActivityModel(name: "test")
            //when
            let activityFromDB = try sut.save(activityModel: activity)
            
            XCTAssertNotNil(activityFromDB.id)
            XCTAssertEqual(activity.name, activityFromDB.name)
            
        } catch {
            //then
            throw ActivityTimerTestsError.error
        }
    }
    
    /// Test save method when database throws error
    func test_save_whenDatabaseThrowsError() throws {
        
        managedObjectContextMock.shouldThrowOnSave = true
        
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
    
    ///Test delete method that should delete item from db
    func test_delete_shouldDeleteItemFromDatabase() throws {
        
        managedObjectContextMock.activityIndex = 0
        
        do {
            //given
            let activity = ActivityModel(id: URL(string: "test1"), name: "test")
            //when
            try sut.delete(activityModel: activity)
            
        } catch ServiceError.databaseError {
            //then
            throw ActivityTimerTestsError.error
        }
    }
    
    /// Test delete method when no item found should throws error
    func test_delete_whenNoItemFound_shouldThrowsError() throws {
        
        managedObjectContextMock.activityIndex = 0
        managedObjectContextMock.shouldFoundNoItem = true
        
        do {
            //given
            let activity = ActivityModel(id: URL(string: "test1"), name: "test")
            //when
            try sut.delete(activityModel: activity)
            
        } catch ServiceError.noItemsFound {
            //test passed
            return
        }
        
        //then
        //test failed
        throw ActivityTimerTestsError.error
    }
    
    ///Test delete method when database throws error
    func test_delete_WhenDatabaseThrowException() throws {
        
        managedObjectContextMock.activityIndex = 0
        managedObjectContextMock.shouldThrowOnSave = true
        
        do {
            //given
            let activity = ActivityModel(id: URL(string: "test1"), name: "test")
            //when
            try sut.delete(activityModel: activity)
            
        } catch ServiceError.databaseError {
            return
        }
        
        //then
        throw ActivityTimerTestsError.unitTestError
    }
    
    /// Test update method should save data in database with success
    func test_update_shouldSaveItemInDatabase() throws {
        
        managedObjectContextMock.activityIndex = 0
        
        do {
            //given
            let activity = ActivityModel(name: "test")
            //when
            try sut.update(id: URL(string: "test1"), activityModel: activity)
            
        } catch ServiceError.databaseError {
            //then
            throw ActivityTimerTestsError.error
        }
    }
    
    /// Test update method when no item found should throws error
    func test_update_whenNoItemFound_shouldThrowsError() throws {
        
        managedObjectContextMock.activityIndex = 0
        managedObjectContextMock.shouldFoundNoItem = true
        
        do {
            //given
            let activity = ActivityModel(name: "test")
            //when
            try sut.update(id: URL(string: "test1"), activityModel: activity)
            
        } catch ServiceError.noItemsFound {
            //test passed
            return
        }
        
        //then
        //test failed
        throw ActivityTimerTestsError.error
    }
    
    ///Test update method when database throws error
    func test_update_WhenDatabaseThrowException() throws {
        
        managedObjectContextMock.activityIndex = 0
        managedObjectContextMock.shouldThrowOnSave = true
        
        do {
            //given
            let activity = ActivityModel(id: URL(string: "test1"), name: "test")
            //when
            try sut.update(id: URL(string: "test1"), activityModel: activity)
            
        } catch ServiceError.databaseError {
            return
        }
        
        //then
        throw ActivityTimerTestsError.unitTestError
    }
    
    //Clean data after each test
    override func tearDown() {
        managedObjectContextMock = nil
        sut = nil
        
    }
}
