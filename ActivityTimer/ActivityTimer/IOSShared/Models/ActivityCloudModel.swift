//
//  ActivityCloudModel.swift
//  IOSShared
//
//  Created by Krzysztof Maraszkiewicz on 11/07/2019.
//  Copyright © 2019 Krzysztof Maraszkiewicz. All rights reserved.
//

import CloudKit

///Model for cloud kit data
public struct ActivityCloudModel {
    
    ///Data of record from cloud kit storage
    public let record: CKRecord
    
    ///Name of zone in cloud storage
    public static let recordType = "Activity"
    
    ///Name of columns on cloud kit zone
    private struct keys {
        ///id column name for id column on cloud kit zone
        static let id = "id"
        
        ///name column name for name column on cloud kit
        static let name = "name"
    }
    
    ///Set or get value of id from cloud kit storage
    public var id: String {
        get {
            return self.record.value(forKey: keys.id) as! String
        } set {
            self.record.setValue(newValue, forKey: keys.id)
        }
    }
    
    ///Set or get value of name from cloud kit storage
    public var name: String {
        get {
            return self.record.value(forKey: keys.name) as! String
        } set {
            self.record.setValue(newValue, forKey: keys.name)
        }
    }
    
    /// Initialize new instance of struct
    ///
    /// - Parameter record: The data from zone on cloud kit storage
    init(record: CKRecord) {
        self.record = record
    }
    
    
    /// Initialize new instance of struct
    ///
    /// - Parameters:
    ///   - id: The id of activity
    ///   - name: The name of activity
    init(id: String, name: String) {
        self.record = CKRecord(recordType: ActivityCloudModel.recordType)
        
        self.id = id
        self.name = name
    }
}
