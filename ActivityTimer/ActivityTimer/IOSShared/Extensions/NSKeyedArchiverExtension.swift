//
//  NSKeyedArchiverExtension.swift
//  ActivityTimer
//
//  Created by Krzysztof Maraszkiewicz on 06/06/2019.
//  Copyright © 2019 Krzysztof Maraszkiewicz. All rights reserved.
//

import os.log
import UIKit

///Protocol used for mocking NSKeyedArchiver and use it in unit testing
public protocol NSKeyedArchiverProtocol {
    var error: Error? { get }
    
    var encodedData: Data { get }
    
    func encode(_ object: Any?, forKey key: String)
}


// MARK: - NSKeyedArchiverProtocol
extension NSKeyedArchiver: NSKeyedArchiverProtocol {
    
}

///The NSKeyedArchiver extension
public extension NSKeyedArchiver {
    
    ///Property used to injection mocking class or use real data from NSKeyedArchiver class
    static var nsKeyedArchiver: NSKeyedArchiverProtocol? = nil
    
    ///Encodes ActivityModel object to Data object and send this data to push it to watchOS app
    /// - parameter object: The object to encode
    /// - parameter forKey: The name of hashed key
    /// - returns: The Data
    static func encodeActivity(_ object: Any?, forKey: String) -> Data {
        
        let archiver: NSKeyedArchiverProtocol
        
        if NSKeyedArchiver.nsKeyedArchiver == nil {
            archiver = NSKeyedArchiver(requiringSecureCoding: false)
        } else {
            archiver = NSKeyedArchiver.nsKeyedArchiver!
        }
        
        archiver.encode(object, forKey: forKey)
        
        if archiver.encodedData.isEmpty {
            os_log("Archiver encoded data is empty", log: OSLog.nsKeyedArchiverExtension, type: .error)
        }
        
        if let error = archiver.error {
            os_log("Occours error while tring tp encode data. With error: %{PUBLIC}@", log: OSLog.nsKeyedArchiverExtension, type: .error, "\(error)")
        }
        
        return archiver.encodedData
    }
    
}
