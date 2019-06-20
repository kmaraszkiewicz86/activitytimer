//
//  NSCoderMoc.swift
//  ActivityTimerTests
//
//  Created by Krzysztof Maraszkiewicz on 20/06/2019.
//  Copyright © 2019 Krzysztof Maraszkiewicz. All rights reserved.
//

import IOSShared
import UIKit

class NSCoderMock: NSCoderProtocol {
    
    var id: URL?
    var name: String?
    var operationType: String?
    
    func decodeObject(forKey key: String) -> Any? {
        switch key {
        case "id":
            return id
            
        case "name":
            return name
            
        case "operationType":
            return operationType
            
        default:
            fatalError("Key \(key) not implemented")
        }
    }
    
    func encode(_ object: Any?, forKey key: String) {
        
    }
}
