//
//  NSManagedObjectExtension.swift
//  ActivityTimerTests
//
//  Created by Krzysztof Maraszkiewicz on 23/06/2019.
//  Copyright © 2019 Krzysztof Maraszkiewicz. All rights reserved.
//

import CoreData

/// Mock class for NSManagedObjectContextMock for use it in unit tests
class NSManagedObjectContextMock: NSManagedObjectContextProtocol {
    
    var isMockingProtocol: Bool {
        return true
    }
    
    ///The mock version of NSPersistentStoreCoordinator object
    var persistentStoreCoordinatorHelper: NSPersistentStoreCoordinatorProtocol? {
        return NSPersistentStoreCoordinatorMock(self)
    }
    
    /// The CoreDataManager helper to manage database mock
    let context: NSManagedObjectContext
    
    ///The activities items provided from test scenario to injection it to mocking ActivityService class
    var activities: [ActivityModel]?
    
    ///The index of eleemnt from Activities
    var activityIndex: Int?
    
    ///Set to true if mocking save method should throw error
    var shouldThrowOnFetch = false
    
    ///Set to true if mocking save method should throw error
    var shouldThrowOnSave = false
    
    ///Set to true if you want to simulate no item found when user want to get some data from database
    var shouldFoundNoItem = false
    
    
    /// Initialize object of class
    ///
    /// - Parameter context: The instance of NSManagedObjectContext class
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    
    /// Gets NSManagedObjectContext and NSEntityDescription objects
    ///
    /// - Returns: NSManagedObjectContext and NSEntityDescription objects
    private func getContextAndEntityDescription() -> (context: NSManagedObjectContext, descritpion: NSEntityDescription) {
        let description = NSEntityDescription.entity(forEntityName: "Activity", in: context)!
        
        return (context, description)
    }
    
    /// The mock method of fetch from NSManagedObjectContext class
    ///
    /// - Parameter request: The request instqance
    /// - Returns: Returns NSFetchRequestResult object
    /// - Throws:
    func fetch<T>(_ request: NSFetchRequest<T>) throws -> [T] where T : NSFetchRequestResult {
        
        if self.shouldThrowOnFetch {
            throw ActivityTimerTestsError.error
        }
        
        return toNSManagedObjectArray().map({ (managedObject) -> T in
            return managedObject as! T
        })
    }
    
    
    /// The mock of save method from NSManagedObjectContext class
    ///
    /// - Throws: throws error when SManagedObjectContextMock.shouldThrowOnSave property i set to true
    func save() throws {
        if self.shouldThrowOnSave {
            throw ActivityTimerTestsError.error
        }
    }
    
    
    /// The mock of method delete from NSManagedObjectContext class
    ///
    /// - Parameter object: The NSManagedObject object
    func delete(_ object: NSManagedObject) {
    }
    
    func existingObject(with objectID: NSManagedObjectID) throws -> NSManagedObject {
        if !(self.activities?.isEmpty ?? false) {
            return toNSManagedObject(activity: self.activities![self.activityIndex!])
        }
        
        throw ActivityTimerTestsError.error
    }
    
    
    /// Convert activity models to array of NSManagedObject
    ///
    /// - Returns: return array of NSManagedObject
    public func toNSManagedObjectArray () -> [NSManagedObject] {
        
        if let activitiesTmp = self.activities, !activitiesTmp.isEmpty {
            return activitiesTmp.map({ (activity) -> NSManagedObject in
                return toNSManagedObject(activity: activity)
            })
        }
        
        return [NSManagedObject]()
    }
    
    
    /// Converts activity model to NSManagedObject
    ///
    /// - Parameter activity: The activity model tht will be converted
    /// - Returns: returns NSManagedObject object
    public func toNSManagedObject(activity: ActivityModel) -> NSManagedObject {
        
        let contextAndEntityDescription = getContextAndEntityDescription()
        let activityManagedObject = NSManagedObject(entity: contextAndEntityDescription.descritpion, insertInto: contextAndEntityDescription.context)
        
        activityManagedObject.setValue(activity.name, forKey: "name")
        
        return activityManagedObject
    }
}
