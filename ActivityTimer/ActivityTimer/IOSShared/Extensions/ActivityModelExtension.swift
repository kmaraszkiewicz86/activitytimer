//
//  ActivityModelExtension.swift
//  IOSShared
//
//  Created by Krzysztof Maraszkiewicz on 12/07/2019.
//  Copyright © 2019 Krzysztof Maraszkiewicz. All rights reserved.
//

import os.log

///ActivityModel extensions methods
public extension ActivityModel {
    
    
    /// Converts ActivityModel to ActivityCloudModel type object
    ///
    /// - Returns: returns converted ActivityCloudModel type object
    func toActivityCloudModel() -> ActivityCloudModel {
        guard let id = id else {
            os_log("The activity identifier is required", log: OSLog.activityModelExtension, type: .error)
            fatalError("The activity identifier is required")
        }
        
        return ActivityCloudModel(id: id, name: name)
    }
    
}
