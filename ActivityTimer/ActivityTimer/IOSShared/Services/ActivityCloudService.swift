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
    /// - Parameter activityModel: The activity data
    func save(activityModel: ActivityCloudModel,
              onSuccess: @escaping () -> Void)
}

///Manages activity type on ICloudKit storage
public class ActivityCloudService: ActivityCloudServiceProtocol {
    
    /// Conncetion of cloud kit default database
    private lazy var database: CKDatabase = {
        return CKContainer.default().privateCloudDatabase
    }()
    
    private var onError: (String?) -> Void
    
    init (onError: @escaping (String?) -> Void) {
        self.onError = onError
    }
    
    /// Save activity to database
    ///
    /// - Parameter activityModel: The activity data
    public func save(activityModel: ActivityCloudModel, onSuccess: @escaping () -> Void) {
        
        database.save(activityModel.record, completionHandler: {
            (record: CKRecord?, error: Error?) in
            if error != nil {
                os_log("Save item to storage finish with error %{PUBLIC}%", log: OSLog.activityCloudService, type: .error, String(describing: error))
                
                self.onError(String(describing: error))
                return
            }
            
            onSuccess()
        })
    }
}
