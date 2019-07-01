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
    func fetch<T>(_ request: NSFetchRequest<T>) throws -> [T] where T : NSFetchRequestResult
    func save() throws
    func delete(_ object: NSManagedObject)
    func existingObject(with objectID: NSManagedObjectID) throws -> NSManagedObject
}

extension NSManagedObjectContext: NSManagedObjectContextProtocol {
    
}