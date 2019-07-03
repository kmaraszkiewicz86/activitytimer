//
//  NSManagedObjectContextExtension.swift
//  IOSShared
//
//  Created by Krzysztof Maraszkiewicz on 22/06/2019.
//  Copyright © 2019 Krzysztof Maraszkiewicz. All rights reserved.
//

import CoreData

///Protocol used for mocking and use it in unit testing
public protocol NSManagedObjectContextProtocol {
    
    var isMockingProtocol: Bool { get }
    var persistentStoreCoordinatorHelper: NSPersistentStoreCoordinatorProtocol? { get }
    var context: NSManagedObjectContext { get }
    
    func fetch<T>(_ request: NSFetchRequest<T>) throws -> [T] where T : NSFetchRequestResult
    func save() throws
    func delete(_ object: NSManagedObject)
    func existingObject(with objectID: NSManagedObjectID) throws -> NSManagedObject
}

///Add to NSManagedObjectContext class NSManaggedObjectContextProtocol and inject methods to help running unit tests
extension NSManagedObjectContext: NSManaggedObjectContextProtocol {
    
    ///Variable stub to mocking NSManagedObjectContext on unit testing
    public var context: NSManagedObjectContext {
        return self
    }
    
    ///Get info if NSManagedObjectContext is in mock state
    ///Helps with working with singleton instance of ActivityService
    public var isMockingProtocol: Bool {
        return false
    }
    
    ///Used for mocking NSPersistentStoreCoordinator class
    public var persistentStoreCoordinatorHelper: NSPersistentStoreCoordinatorProtocol? {
        return self.persistentStoreCoordinator
    }
}
