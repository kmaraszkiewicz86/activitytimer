//
//  CoreDataManager.swift
//  ActivityTimerTests
//
//  Created by Krzysztof Maraszkiewicz on 20/06/2019.
//  Copyright © 2019 Krzysztof Maraszkiewicz. All rights reserved.
//

import CoreData

class CoreDataManger {
    
    //MARK: singleton
    static let shared = CoreDataManger()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let persistentContainer = NSPersistentContainer(name: "ActivityTimer")
        
        return persistentContainer
    }()
    
    lazy var mainContext: NSManagedObjectContext = {
        let context = self.persistentContainer.viewContext
        context.automaticallyMergesChangesFromParent = true
        
        return context
    }()
    
    func setup (completion: @escaping () -> Void) {
        loadPersistentContainer {
            completion()
        }
    }
    
    func loadPersistentContainer (completion: @escaping () -> Void) {
        self.persistentContainer.loadPersistentStores { description, error in
            guard error == nil else {
                fatalError("Could not load store \(error!)")
            }
            
            completion()
            
        }
    }
    
}
