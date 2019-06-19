//
//  WCSessionExtensionMock.swift
//  ActivityTimerTests
//
//  Created by Krzysztof Maraszkiewicz on 19/06/2019.
//  Copyright © 2019 Krzysztof Maraszkiewicz. All rights reserved.
//

import UIKit
import IOSShared

class WCSessionExtensionMock: WCSessionProtocol {
    
    var isWatchAppInstalled: Bool = true
    
    var isReachable: Bool = true
    
    var isPaired: Bool = true
    
    var isSupported: Bool = true
    
    func sendMessageData(_ data: Data, replyHandler: ((Data) -> Void)?, errorHandler: ((Error) -> Void)?) {
        
    }
}
