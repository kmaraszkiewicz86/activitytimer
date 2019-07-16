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
    
    ///Used for dependency injection or to set up object for real envinronment
    private static var nsCoder: NSCoderProtocol?
    
    ///Class properties names for NSKeyedArchiver or NSKeyedUnarchived classes
    struct Keys {
        static let idKeyName = "id"
        static let nameKeyName = "name"
        static let operationTypeKeyName = "operationType"
    }
    
    //The activity identifier
    public var id: URL?
    
    ///The name of activity
    public var name: String
    
    ///The operation activity ty
    public var operationType: ActivityOperationType?
    
    ///Initialize data for NSCoding decode
    required convenience public init(coder deCoder: NSCoder) {
        self.init(coderMock: deCoder)
    }
    
    
    /// Initialize object from NSKeyedUnarchiver object
    ///
    /// - Parameter deCoderMock: NSCoder protocol used to dependency injection data from mock class for unit testing or NSCoder class
    public convenience init(coderMock deCoderMock: NSCoderProtocol) {
        let id = deCoderMock.decodeObject(forKey: Keys.idKeyName) as? URL
        let name = deCoderMock.decodeObject(forKey: Keys.nameKeyName) as! String
        let operationTypeInt = deCoderMock.decodeObject(forKey: Keys.operationTypeKeyName) as? Int
        
        self.init(id: id, name: name, operationTypeInt: operationTypeInt)
    }
    
    ///Initializer to create instance of class
    ///
    /// - Parameters:
    ///   - id: The ActivityModel identifier
    ///   - name: The name of ActivityModel
    public init(id: URL?, name: String) {
        self.id = id
        self.name = name
    }
    
    /// Inilialize instrance of class
    ///
    /// - Parameters:
    ///   - id: The ActivityModel identifier
    ///   - name: The ActivityModel name
    ///   - operationTypeInt: The Int type of operation that was processed
    convenience public init(id: URL?, name: String, operationTypeInt: Int?) {
        self.init(id: id, name: name)
        
        self.operationType = toActivityOperationType(type: operationTypeInt)
    }
    
    
    /// Inilialize instrance of class
    ///
    /// - Parameters:
    ///   - id: The ActivityModel identifier
    ///   - name: The ActivityModel name
    ///   - operationTypeInt: The ActivityOperationType enum type of operation that was processed
    convenience public init(id: URL?, name: String, operationType: ActivityOperationType?) {
        self.init(id: id, name: name)
        
        self.operationType = operationType
    }
    
    ///initializes Activity object
    /// - parameter name: The activity name
    public init(name: String) {
        self.name = name
    }
    
    
    /// The method for encode data for NSKeyedArchiver class
    ///
    /// - Parameter aCoderMock: The protocol of dependecy injection of NSCoder used for unit testing or real data
    public func encode(withMock aCoderMock: NSCoderProtocol) {
        aCoderMock.encode(self.id, forKey: Keys.idKeyName)
        aCoderMock.encode(self.name, forKey: Keys.nameKeyName)
        aCoderMock.encode(toInt(type: self.operationType), forKey: Keys.operationTypeKeyName)
    }
    
    ///The wrapper method for encoding data
    /// - parameter aCoder: NSCoder object
    public func encode(with aCoder: NSCoder) {
        self.encode(withMock: aCoder)
    }
    
    ///Convert ActivityOperationType to integer
    ///- returns: The int value of ActivityOperationType
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
