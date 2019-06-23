//
//  NSManagedObjectContextExtension.swift
//  IOSShared
//
//  Created by Krzysztof Maraszkiewicz on 22/06/2019.
//  Copyright © 2019 Krzysztof Maraszkiewicz. All rights reserved.
//

import CoreData

public protocol NSManagedObjectContextProtocol {
    func fetch<T>(_ request: NSFetchRequest<T>) throws -> [T] where T : NSFetchRequestResult
    func save() throws
    func delete(_ object: NSManagedObject)
    func existingObject(with objectID: NSManagedObjectID) throws -> NSManagedObject
}

public protocol NSEntityDescriptionProtocol {
    static func entity(forEntityName: String, in: NSManagedObjectContextProtocol)
}

public protocol NSPersistentStoreCoordinatorProtocol {
    
}

extension NSManagedObjectContext: NSManagedObjectContextProtocol {
    
}
