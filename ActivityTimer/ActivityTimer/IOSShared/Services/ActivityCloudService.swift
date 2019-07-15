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
    
    /// Deletes activity by id
    ///
    /// - Parameters:
    ///   - id: The activity indentifier
    ///   - onSuccess: Trigger when action ends with success
    func delete(id: URL?, onSuccess: @escaping () -> Void)
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
            
            if self.isErrorExists("Save item to storage finish with error %{PUBLIC}%", error) {
                return
            }
            
            onSuccess()
        })
    }
    
    
    /// Deletes activity by id
    ///
    /// - Parameters:
    ///   - id: The activity indentifier
    ///   - onSuccess: Trigger when action ends with success
    public func delete(id: URL?, onSuccess: @escaping () -> Void) {
        
        guard let idTmp = id else {
            sendError(logMessage: "The id parameter is required", errorMessage: "The id parameter is required")
            return
        }
        
        let query = CKQuery(recordType: ActivityCloudModel.recordType, predicate: NSPredicate(format: "id=%@", String(describing: idTmp)))
        
        self.database.perform(query, inZoneWith: nil) { (records, error) in
            if self.isErrorExists("Could not found item with error %{PUBLIC}%", error) {
                return
            }
            
            if records != nil && records!.count > 0 {
                
                for record in records! {
                    
                    self.database.delete(withRecordID: record.recordID, completionHandler: { (id, error) in
                        
                        if self.isErrorExists("Could not found item with error %{PUBLIC}%", error) {
                            return
                        }
                        
                        onSuccess()
                    })
                }
            }
        }
    }
    
    private func isErrorExists(_ logMessage: StaticString, _ error: Error?) -> Bool {
        if error != nil {
            sendError(logMessage: logMessage, errorMessage: String(describing: error))
            return true
        }
        
        return false
    }
    
    private func sendError (logMessage: StaticString, errorMessage: String) {
        os_log(logMessage, log: OSLog.activityCloudService, type: .error, String(describing: error))
        
        self.onError(errorMessage)
    }
}
