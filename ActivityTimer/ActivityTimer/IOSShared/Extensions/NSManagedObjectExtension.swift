//
//  NSManagedObjectExtension.swift
//  ActivityTimer
//
//  Created by Krzysztof Maraszkiewicz on 27/05/2019.
//  Copyright © 2019 Krzysztof Maraszkiewicz. All rights reserved.
//

import CoreData

///The NSManagedObject extensions
public extension NSManagedObject {
    
    ///Name of columns on cloud kit zone
    private struct keys {
        ///id column name for id column on cloud kit zone
        static let id = "id"
        
        ///name column name for name column on cloud kit
        static let name = "name"
    }
    
    ///Get identigier of NSManagedObject object
    private var id: URL {
        return objectID.uriRepresentation()
    }
    
    ///Get name of NSManagedObject object
    private var name: String {
        return self.value(forKey: keys.name) as! String
    }
    
    /// Convert NSManagedObject to ActivityModel object
    ///
    /// - Returns: return converted ActivityModeol object
    func toActivityModel () -> ActivityModel {
        return ActivityModel(id: self.id, name: self.name)
    }
    
    /// Converts NSManagedObject to ActivityCloudModel type object
    ///
    /// - Returns: returns converted ActivityCloudModel type object
    func toActivityCloudModel() -> ActivityCloudModel {
    
        return ActivityCloudModel(id: String(describing: self.id),
                                  name: self.name)
    }
}
