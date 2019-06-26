//
//  NSCoderMoc.swift
//  ActivityTimerTests
//
//  Created by Krzysztof Maraszkiewicz on 20/06/2019.
//  Copyright © 2019 Krzysztof Maraszkiewicz. All rights reserved.
//

import UIKit

class NSCoderMock: NSCoderProtocol {
    
    var id: URL?
    var name: String?
    var operationType: Int?
    
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
        switch key {
        case "id":
            id = URL(string: String(describing: object ?? ""))
            break
            
        case "name":
            name = String(describing: object ?? "")
            break
            
        case "operationType":
            operationType = object as? Int ?? 0
            break
            
        default:
            fatalError("Key \(key) not implemented")
        }
    }
}
