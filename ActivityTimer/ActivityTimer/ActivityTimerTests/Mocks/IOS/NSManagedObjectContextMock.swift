//
//  NSManagedObjectExtension.swift
//  ActivityTimerTests
//
//  Created by Krzysztof Maraszkiewicz on 23/06/2019.
//  Copyright © 2019 Krzysztof Maraszkiewicz. All rights reserved.
//

import IOSShared
import CoreData


/// Mock class for NSManagedObjectContextMock for use it in unit tests
class NSManagedObjectContextMock: NSManagedObjectContextProtocol {
    
    /// The CoreDataManager helper to manage database mock
    let coreDataManager = CoreDataManger.shared
    
    ///The activities items provided from test scenario to injection it to mocking ActivityService class
    var activities: [ActivityModel]?
    var activityIndex: Int?
    var shouldThrowOnSave = false
    
    private func getContextAndEntityDescription() -> (context: NSManagedObjectContext, descritpion: NSEntityDescription) {
        let context = coreDataManager.mainContext
        let description = NSEntityDescription.entity(forEntityName: "Activity", in: context)!
        
        return (context, description)
    }
    
    func fetch<T>(_ request: NSFetchRequest<T>) throws -> [T] where T : NSFetchRequestResult {
        return toNSManagedObjectArray().map({ (managedObject) -> T in
            return managedObject as! T
        })
    }
    
    func save() throws {
        if shouldThrowOnSave {
            throw ActivityTimerTestsError.error
        }
    }
    
    func delete(_ object: NSManagedObject) {
    }
    
    func existingObject(with objectID: NSManagedObjectID) throws -> NSManagedObject {
        if !(activities?.isEmpty ?? false) {
            return toNSManagedObject(activity: activities![activityIndex!])
        }
        
        throw ActivityTimerTestsError.error
    }
    
    public func toNSManagedObjectArray () -> [NSManagedObject] {
        
        if let activitiesTmp = activities, !activitiesTmp.isEmpty {
            return activitiesTmp.map({ (activity) -> NSManagedObject in
                return toNSManagedObject(activity: activity)
            })
        }
        
        return [NSManagedObject]()
    }
    
    public func toNSManagedObject(activity: ActivityModel) -> NSManagedObject {
        
        let contextAndEntityDescription = getContextAndEntityDescription()
        let activityManagedObject = NSManagedObject(entity: contextAndEntityDescription.descritpion, insertInto: contextAndEntityDescription.context)
        
        activityManagedObject.setValue(activity.name, forKey: "name")
        
        return activityManagedObject
    }
}
