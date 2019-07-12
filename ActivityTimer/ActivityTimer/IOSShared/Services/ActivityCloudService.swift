//
//  ActivityCloudService.swift
//  IOSShared
//
//  Created by Krzysztof Maraszkiewicz on 10/07/2019.
//  Copyright © 2019 Krzysztof Maraszkiewicz. All rights reserved.
//

import CloudKit
import os.log

///ActivityCloudService protocol
public protocol ActivityCloudServiceProtocol {
    /// Save activity to database
    ///
    /// - Parameter activity: The activity data
    func save(activity: ActivityCloudModel, onError: @escaping (Error?) -> Void)
}

///Manages activity type on ICloudKit storage
public class ActivityCloudService: ActivityCloudServiceProtocol {
    
    /// Conncetion of cloud kit default database
    private lazy var database: CKDatabase = {
        return CKContainer.default().privateCloudDatabase
    }()
    
    /// Save activity to database
    ///
    /// - Parameter activity: The activity data
    public func save(activity: ActivityCloudModel, onError: @escaping (Error?) -> Void) {
        
        database.save(activity.record, completionHandler: {
            (record: CKRecord?, error: Error?) in
            if error != nil {
                os_log("Save item to storage finish with error %{PUBLIC}%", log: OSLog.activityCloudService, type: .error, String(describing: error))
                
                onError(error)
            }
        })
    }
}
