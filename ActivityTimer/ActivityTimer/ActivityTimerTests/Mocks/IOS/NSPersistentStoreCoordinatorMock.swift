//
//  NSPersistentStoreCoordinatorMock.swift
//  ActivityTimer
//
//  Created by Krzysztof Maraszkiewicz on 03/07/2019.
//  Copyright © 2019 Krzysztof Maraszkiewicz. All rights reserved.
//

import CoreData

class NSPersistentStoreCoordinatorMock: NSPersistentStoreCoordinatorProtocol {
    
    let managedObjectContextMock: NSManagedObjectContextMock!
    
    init (_ managedObjectContextMock: NSManagedObjectContextMock) {
        self.managedObjectContextMock = managedObjectContextMock
    }
    
    func managedObjectID(forURIRepresentation url: URL) -> NSManagedObjectID? {
        
        if self.managedObjectContextMock.shouldFoundNoItem {
            return nil
        }
        
        return self.managedObjectContextMock.toNSManagedObject(activity: self.managedObjectContextMock.activities![self.managedObjectContextMock.activityIndex!]).objectID
    }
}
