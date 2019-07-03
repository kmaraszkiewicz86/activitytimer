//
//  NSPersistentStoreCoordinatorExtension.swift
//  ActivityTimer
//
//  Created by Krzysztof Maraszkiewicz on 03/07/2019.
//  Copyright © 2019 Krzysztof Maraszkiewicz. All rights reserved.
//

import CoreData

///Protocol for mocking NSPersistentStoreCoordinator used by unit tests
public protocol NSPersistentStoreCoordinatorProtocol {
    
    func managedObjectID(forURIRepresentation url: URL) -> NSManagedObjectID?
    
}

extension NSPersistentStoreCoordinator: NSPersistentStoreCoordinatorProtocol {
    
}
