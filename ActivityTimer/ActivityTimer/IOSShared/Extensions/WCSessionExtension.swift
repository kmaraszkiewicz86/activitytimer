//
//  WCSessionExtension.swift
//  ActivityTimer
//
//  Created by Krzysztof Maraszkiewicz on 02/06/2019.
//  Copyright © 2019 Krzysztof Maraszkiewicz. All rights reserved.
//

import os.log
import WatchConnectivity

///Protocol used to mockig WCSession class for unit tests
public protocol WCSessionProtocol {
    var isWatchAppInstalled: Bool { get }
    var isReachable: Bool { get }
    var isPaired: Bool { get }
    
    var isSupported: Bool { get }
    
    func sendMessageData(_ data: Data, replyHandler: ((Data) -> Void)?, errorHandler: ((Error) -> Void)?)
}


// MARK: - WCSessionProtocol
extension WCSession : WCSessionProtocol {
    
    public var isSupported: Bool {
        return WCSession.isSupported()
    }
    
}


///WCSession extension class
extension WCSession {
    
    ///Property used to injection mocking class or WCSession for application running on iPhone
    public static var session: WCSessionProtocol?
    
    
    /// Get if session is supported
    ///This property used for injection mocking isupported value or real value from WCSession, when app running on iPhone
    private static var isSupported: Bool {
        return session == nil ? WCSession.isSupported() : session!.isSupported
    }
    
    ///Check if iPhone can connect to watchOS app and to starting sending information to watchOS app
    /// - parameter session: Session of watchkit
    /// - parameter sessionAction: Session run if session is in valid status
    /// - parameter onError: Action run if session has invalid state
    public static func initIOSSession(session: WCSessionProtocol?, sessionAction: (WCSessionProtocol) -> Void)
    {
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
