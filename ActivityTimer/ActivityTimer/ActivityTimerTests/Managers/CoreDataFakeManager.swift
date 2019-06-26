//
//  CoreDataManager.swift
//  ActivityTimerTests
//
//  Created by Krzysztof Maraszkiewicz on 20/06/2019.
//  Copyright © 2019 Krzysztof Maraszkiewicz. All rights reserved.
//

import CoreData

///Mock of CoreData fake base classes required by unit tests
class CoreDataFakeManager {
    
    ///Replace NSManagedObjectContext on real application with fake mocking object
    static func setupInMemoryManagedObjectContext() -> NSManagedObjectContextProtocol {
        let container = NSPersistentContainer(name: "ActivityTimer")
        
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return NSManagedObjectContextMock(context: container.viewContext)
    }
}
