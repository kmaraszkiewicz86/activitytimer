//
//  CoreDataManager.swift
//  ActivityTimerTests
//
//  Created by Krzysztof Maraszkiewicz on 20/06/2019.
//  Copyright © 2019 Krzysztof Maraszkiewicz. All rights reserved.
//

import CoreData

///Mock of CoreData base classes
class CoreDataManger {
    
    //MARK: singleton
    ///Singleton of class
    static let shared = CoreDataManger()
    
    ///Get mock version of NSPersistentContainer class
    lazy var persistentContainer: NSPersistentContainer = {
        let persistentContainer = NSPersistentContainer(name: "ActivityTimer")
        
        persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return persistentContainer
    }()
    
    
    /// The mock of main context of NSManagedObjectContext class
    lazy var mainContext: NSManagedObjectContext = {
        let context = self.persistentContainer.viewContext
        //context.automaticallyMergesChangesFromParent = true
        
        return context
    }()
}
