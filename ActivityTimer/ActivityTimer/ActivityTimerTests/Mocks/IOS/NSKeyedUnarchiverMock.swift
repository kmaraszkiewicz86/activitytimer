//
//  NSKeyedUnarchiverMock.swift
//  ActivityTimerTests
//
//  Created by Krzysztof Maraszkiewicz on 16/06/2019.
//  Copyright © 2019 Krzysztof Maraszkiewicz. All rights reserved.
//

import UIKit
import IOSShared

enum NSKeyedArchiverMockError: Error {
    case errorMock
}

class NSKeyedArchiverMock: NSKeyedArchiverProtocol {
    
    var data: Data?
    var errorMessage: String?
    
    var error: Error?
    {
        get {
            return NSKeyedArchiverMockError.errorMock
        }
    }
    
    var encodedData: Data {
        get {
            return data!
        }
    }
    
    func encode(_ object: Any?, forKey key: String) {
        
    }
}
