//
//  NSManagedObjectExtension.swift
//  ActivityTimerTests
//
//  Created by Krzysztof Maraszkiewicz on 23/06/2019.
//  Copyright © 2019 Krzysztof Maraszkiewicz. All rights reserved.
//

import IOSShared
import CoreData

class NSManagedObjectContextMock: NSManagedObjectContextProtocol {
    
    let coreDataManager = CoreDataManger.shared
    var activities: [ActivityModel]?
    var activityIndex: Int?
    var shouldThrowOnSave = false
    
    private func getContextAndEntityDescription() -> (context: NSManagedObjectContext, descritpion: NSEntityDescription) {
        let context = coreDataManager.mainContext
        let description = NSEntityDescription.entity(forEntityName: "Activity", in: context)!
        
        return (context, description)
    }
    
    func fetch<T>(_ request: NSFetchRequest<T>) throws -> [T] where T : NSFetchRequestResult {
        return toNSManagedObjectArray() as! [T]
    }
    
    func save() throws {
        if shouldThrowOnSave {
            throw ActivityTimerTestsError.error
        }
    }
    
    func delete(_ object: NSManagedObject) {
    }
    
    func existingObject(with objectID: NSManagedObjectID) throws -> NSManagedObject {
        return toNSManagedObject(activity: activities![activityIndex!])
    }
    
    public func toNSManagedObjectArray () -> [NSManagedObject] {
        return self.activities!.map({ (activity) -> NSManagedObject in
            return toNSManagedObject(activity: activity)
        })
    }
    
    public func toNSManagedObject(activity: ActivityModel) -> NSManagedObject {
        
        let contextAndEntityDescription = getContextAndEntityDescription()
        let activityManagedObject = NSManagedObject(entity: contextAndEntityDescription.descritpion, insertInto: contextAndEntityDescription.context)
        
        activityManagedObject.setValue(activity.name, forKey: "name")
        
        return activityManagedObject
    }
}
