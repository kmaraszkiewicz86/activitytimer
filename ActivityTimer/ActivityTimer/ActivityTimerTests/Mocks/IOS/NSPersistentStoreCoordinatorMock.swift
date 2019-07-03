//
//  NSPersistentStoreCoordinatorMock.swift
//  ActivityTimer
//
//  Created by Krzysztof Maraszkiewicz on 03/07/2019.
//  Copyright © 2019 Krzysztof Maraszkiewicz. All rights reserved.
//

import CoreData

///The mock version of persistentStoreCoordinator class
class NSPersistentStoreCoordinatorMock: NSPersistentStoreCoordinatorProtocol {
    
    ///Get NSManagedObjectContextMock instance for using its methods
    let managedObjectContextMock: NSManagedObjectContextMock!
    
    ///The intialize instance of NSManagedObjectContextMock class
    init (_ managedObjectContextMock: NSManagedObjectContextMock) {
        self.managedObjectContextMock = managedObjectContextMock
    }
    
    ///Mocking managedObjectID method of NSPersistentStoreCoordinator class
    func managedObjectID(forURIRepresentation url: URL) -> NSManagedObjectID? {
        
        //to simulate empty database response
        if self.managedObjectContextMock.shouldFoundNoItem {
            return nil
        }
        
        return self.managedObjectContextMock.toNSManagedObject(activity: self.managedObjectContextMock.activities![self.managedObjectContextMock.activityIndex!]).objectID
    }
}
