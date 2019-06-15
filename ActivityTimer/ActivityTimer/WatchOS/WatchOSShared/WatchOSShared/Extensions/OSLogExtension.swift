//
//  OSLogExtension.swift
//  ActivityTimer
//
//  Created by Krzysztof Maraszkiewicz on 25/05/2019.
//  Copyright © 2019 Krzysztof Maraszkiewicz. All rights reserved.
//

import UIKit
import os.log

///The OSLog extension
public extension OSLog {
 
    ///The bundle indetifier
    private static var bundle = Bundle.main.bundleIdentifier!
    
    ///The ActivityInterfaceController name for oslog class
    static let activityInterfaceController = OSLog(subsystem: bundle, category: "ActivityInterfaceController")
    
    ///The NSKeyedUnarchiverExtension name for oslog class
    static let nsKeyedUnarchiverExtension = OSLog(subsystem: bundle, category: "NSKeyedUnarchiverExtension")
    
    ///The InitSession name for oslog class
    static let initSession = OSLog(subsystem: bundle, category: "InitIOSSession")
}
