//
//  ActivityCloudService.swift
//  IOSShared
//
//  Created by Krzysztof Maraszkiewicz on 10/07/2019.
//  Copyright © 2019 Krzysztof Maraszkiewicz. All rights reserved.
//

import CloudKit
import UIKit
import os.log

///Manages activity type on ICloudKit storage
public class ActivityCloudService {
    
    /// Conncetion of cloud kit default database
    private lazy var database: CKDatabase = {
        return CKContainer.default().privateCloudDatabase
    }()
    
    ///On error action. Run when on database action occours error
    private var onError: (error: Error?) -> Void
    
    
    /// IKnitialize class
    ///
    /// - Parameter onError: On error action. Run when on database action occours error
    init(onError: (error: Error) -> Void) {
        self.onError = onError
    }
    
    
    /// Save activity to database
    ///
    /// - Parameter activity: The activity data
    public func save(activity: ActivityCloudModel) {
        database.save(activity) { (record, error) in
            if error != nil {
                onError(error)
            }
        }
    }
}

public protocol ActivityCloudServiceProtocol {
    /// Conncetion of cloud kit default database
    private var database: CKDatabase { get }
    
    ///On error action. Run when on database action occours error
    private var onError: (error: Error?) -> Void
    
    
    /// Save activity to database
    ///
    /// - Parameter activity: The activity data
    public func save(activity: ActivityCloudModel)
}

public extension ActivityModel {
    
    func toActivityCloudModel() -> ActivityCloudModel {
        guard let id = id else {
            os_log("The activity identifier is required", log: OSLog.activityModelExtension, type: .error)
            fatalError("The activity identifier is required")
        }
        
        return ActivityCloudModel(id: id, name: name)
    }
    
}

