//
//  WCSessionExtension.swift
//  ActivityTimer
//
//  Created by Krzysztof Maraszkiewicz on 02/06/2019.
//  Copyright © 2019 Krzysztof Maraszkiewicz. All rights reserved.
//

import os.log
import WatchConnectivity

public protocol WCSessionProtocol {
    static func initIOSSession(session: WCSession?, sessionAction: (WCSession) -> Void)
}

///WCSession extension class
extension WCSession: WCSessionProtocol {
    
    ///Create new IOS instance of watch kit session
    /// - parameter session: Session of watchkit
    /// - parameter sessionAction: Session run if session is in valid status
    /// - parameter onError: Action run if session has invalid state
    public static func initIOSSession(session: WCSession?, sessionAction: (WCSession) -> Void) {
        
        let isSupported = WCSession.isSupported()
        let isReachable = session?.isReachable ?? false
        let isWatchAppInstalled = session?.isWatchAppInstalled ?? false
        let isPaired = session?.isPaired ?? false
        var errorType = ""
        
        if !isSupported {
            errorType = " supported"
        } else if !isReachable {
            errorType = " reachable"
        } else if !isWatchAppInstalled {
            errorType = " watch app not istalled"
        } else if !isPaired {
            errorType = " nor paired"
        }
        
        if !isSupported || !isReachable || !isWatchAppInstalled || !isPaired {
            
            os_log("Watch session is not %{PUBLIC}@", log: OSLog.initIOSSession, type: .error, errorType)
            return
        }
        
        sessionAction(session!)
    }
}
