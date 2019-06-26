//
//  WCSessionExtension.swift
//  ActivityTimer
//
//  Created by Krzysztof Maraszkiewicz on 02/06/2019.
//  Copyright © 2019 Krzysztof Maraszkiewicz. All rights reserved.
//

import WatchConnectivity
import os.log

public protocol WCSessionProtocol {
    static func initSession(session: WCSession?, sessionAction: (WCSession) -> Void,
                            _ onError: (String) -> Void)
}

///WCSession extension class
extension WCSession: WCSessionProtocol {
    
    ///Create new IOS instance of watch kit session
    /// - parameter session: Session of watchkit
    /// - parameter sessionAction: Session run if session is in valid status
    /// - parameter onError: Action run if session has invalid state
    public static func initSession(session: WCSession?, sessionAction: (WCSession) -> Void,
                                   _ onError: (String) -> Void) {
        
        let isSupported = WCSession.isSupported()
        let isReachable = session?.isReachable ?? false
        var errorType = ""
        
        if !isSupported {
            errorType = " supported"
        } else if !isReachable {
            errorType = " reachable"
        }
        
        if !isSupported || !isReachable {
            
            os_log("Watch session is not %{PUBLIC}@", log: OSLog.initSession, type: .error, errorType)
            onError(errorType)
        }
        
        sessionAction(session!)
    }
}
