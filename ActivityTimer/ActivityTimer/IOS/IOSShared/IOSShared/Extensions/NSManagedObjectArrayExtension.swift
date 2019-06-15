//
//  NSManagedObjectArrayExtension.swift
//  ActivityTimer
//
//  Created by Krzysztof Maraszkiewicz on 11/06/2019.
//  Copyright © 2019 Krzysztof Maraszkiewicz. All rights reserved.
//

import CoreData
import Foundation

public extension Array where Element: NSManagedObject{
    
    func toActivityModel () -> [ActivityModel] {
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
