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
    
    /// The CoreDataManager helper to manage database mock
    let context: NSManagedObjectContext
    
    ///The activities items provided from test scenario to injection it to mocking ActivityService class
    static var activities: [ActivityModel]?
    
    ///The index of eleemnt from Activities
    static var activityIndex: Int?
    
    ///Set to true if mocking save method should throw error
    static var shouldThrowOnSave = false
    
    
    /// Initialize object of class
    ///
    /// - Parameter context: The instance of NSManagedObjectContext class
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    
    /// The mock method of fetch from NSManagedObjectContext class
    ///
    /// - Parameter request: The request instqance
    /// - Returns: Returns NSFetchRequestResult object
    /// - Throws:
    func fetch<T>(_ request: NSFetchRequest<T>) throws -> [T] where T : NSFetchRequestResult {
        return toNSManagedObjectArray().map({ (managedObject) -> T in
            return managedObject as! T
        })
    }
    
    
    /// The mock of save method from NSManagedObjectContext class
    ///
    /// - Throws: throws error when SManagedObjectContextMock.shouldThrowOnSave property i set to true
    func save() throws {
        if NSManagedObjectContextMock.shouldThrowOnSave {
            throw ActivityTimerTestsError.error
        }
    }
    
    
    /// The mock of method delete from NSManagedObjectContext class
    ///
    /// - Parameter object: The NSManagedObject object
    func delete(_ object: NSManagedObject) {
    }
    
    func existingObject(with objectID: NSManagedObjectID) throws -> NSManagedObject {
        if !(NSManagedObjectContextMock.activities?.isEmpty ?? false) {
            return toNSManagedObject(activity: NSManagedObjectContextMock.activities![NSManagedObjectContextMock.activityIndex!])
        }
        
        throw ActivityTimerTestsError.error
    }
    
    
    /// Convert activity models to array of NSManagedObject
    ///
    /// - Returns: return array of NSManagedObject
    public func toNSManagedObjectArray () -> [NSManagedObject] {
        
        if let activitiesTmp = NSManagedObjectContextMock.activities, !activitiesTmp.isEmpty {
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
