//
//  NSCoder.swift
//  IOSShared
//
//  Created by Krzysztof Maraszkiewicz on 20/06/2019.
//  Copyright © 2019 Krzysztof Maraszkiewicz. All rights reserved.
//

import UIKit

public protocol NSCoderProtocol {
    func decodeObject(forKey key: String) -> Any?
    func encode(_ object: Any?, forKey key: String)
}

extension NSCoder: NSCoderProtocol {
    
}
