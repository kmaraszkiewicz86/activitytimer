//
//  Activity.swift
//  ActivityTimer
//
//  Created by Krzysztof Maraszkiewicz on 24/05/2019.
//  Copyright © 2019 Krzysztof Maraszkiewicz. All rights reserved.
//

import UIKit

///Activity model storage activity data
@objc(ActivityModel)
public class ActivityModel: NSObject, NSCoding, NSSecureCoding {
    
    ///Is supported security coding
    public static var supportsSecureCoding = true
    
    private static var nsCoder: NSCoderProtocol?
    
    ///Class properties names for NSKeyedArchiver or NSKeyedUnarchived classes
    struct Keys {
        static let idKeyName = "id"
        static let nameKeyName = "name"
        static let operationTypeKeyName = "operationType"
    }
    
    //the activity identifier
    public var id: URL?
    
    ///The name of activity
    public var name: String
    
    ///The operation activity type
    public var operationType: ActivityOperationType?
    
    ///Initialize data for NSCoding decode
    required convenience public init(coder deCoder: NSCoder) {
        self.init(coderMock: deCoder)
    }
    
    public convenience init(coderMock deCoderMock: NSCoderProtocol) {
        let id = deCoderMock.decodeObject(forKey: Keys.idKeyName) as? URL
        let name = deCoderMock.decodeObject(forKey: Keys.nameKeyName) as! String
        let operationTypeInt = deCoderMock.decodeObject(forKey: Keys.operationTypeKeyName) as? Int
        
        self.init(id: id, name: name, operationTypeInt: operationTypeInt)
    }
    
    ///Initializer for shartness data of Activity
    public init(id: URL?, name: String) {
        self.id = id
        self.name = name
    }
    
    ///Initilizer for full activity data with int operation type
    convenience public init(id: URL?, name: String, operationTypeInt: Int?) {
        self.init(id: id, name: name)
        
        self.operationType = toActivityOperationType(type: operationTypeInt)
    }
    
    ///Initializer for full Activity data for operation type of ActivityOperationType enum
    convenience public init(id: URL?, name: String, operationType: ActivityOperationType?) {
        self.init(id: id, name: name)
        
        self.operationType = operationType
    }
    
    ///initializes Activity object
    /// - parameter name: The activity name
    public init(name: String) {
        self.name = name
    }
    
    public func encode(withMock aCoderMock: NSCoderProtocol) {
        self.encode(with: aCoderMock as! NSCoder)
    }
    
    ///encode data
    /// - parameter aCoder: NSCoder object
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: Keys.idKeyName)
        aCoder.encode(self.name, forKey: Keys.nameKeyName)
        aCoder.encode(toInt(type: self.operationType), forKey: Keys.operationTypeKeyName)
    }
    
    public func encodeMock(with aCoder: NSCoder) {
        
    }
    
    ///Convert ActivityOperationType to integer
    ///- returns: The int value od ActivityOperationType
    private func toInt (type: ActivityOperationType?) -> Int? {
        
        if let t = type {
        
            switch t {
                case .added:
                    return 1
                
                case .deleted:
                    return 2
                
                case .updated:
                    return 3
            }
        }
        
        return nil
    }
    
    /// Convert Int to ActivityOperationType
    ///- returns: The ActivityOperationType
    private func toActivityOperationType (type: Int?) -> ActivityOperationType? {
        
        if let t = type {
        
            switch t {
            case 1:
                return .added
                
            case 2:
                return .deleted
                
            case 3:
                return .updated
                
            default:
                return nil
                
            }
        }
        
        return nil
    }
}
