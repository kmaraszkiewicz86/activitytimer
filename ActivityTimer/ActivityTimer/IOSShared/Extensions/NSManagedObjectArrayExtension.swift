//
//  NSManagedObjectArrayExtension.swift
//  ActivityTimer
//
//  Created by Krzysztof Maraszkiewicz on 11/06/2019.
//  Copyright © 2019 Krzysztof Maraszkiewicz. All rights reserved.
//

import CoreData
import Foundation

///Extend NSManagedObject array to convert array of NSManagedObjects to array of ActivityModel objects
public extension Array where Element: NSManagedObject{
    
    ///Converts array of NSManagedObjects to array of ActivityModel objects
    func toActivityModels () -> [ActivityModel] {
        var activities = [ActivityModel]()
        
        if !self.isEmpty {
            for managedObject in self {
                
                let id = managedObject.objectID.uriRepresentation()
                let name = managedObject.value(forKey: "name") as! String
                
                activities.append(ActivityModel(id: id, name: name))
            }
        }
        
        return activities
    }
}
