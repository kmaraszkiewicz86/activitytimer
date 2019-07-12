//
//  OSLogExtension.swift
//  ActivityTimer
//
//  Created by Krzysztof Maraszkiewicz on 25/05/2019.
//  Copyright © 2019 Krzysztof Maraszkiewicz. All rights reserved.
//

import UIKit
import os.log

///The extension for helping categorize logs saved on diffrent file or classws
public extension OSLog {
 
    ///The bundle indetifier
    private static var bundle = Bundle.main.bundleIdentifier!
    
    ///The ActivityTableViewController name for oslog class
    static let activityTableViewController = OSLog(subsystem: bundle, category: "ActivityTableViewController")
    
    ///The ActivityService name for oslog class
    static let activityService = OSLog(subsystem: bundle, category: "ActivityService")
    
    ///The NSKeyedArchiverExtension name for oslog class
    static let nsKeyedArchiverExtension = OSLog(subsystem: bundle, category: "NSKeyedArchiverExtension")
    
    ///The initIOSSession name for oslog class
    static let initIOSSession = OSLog(subsystem: bundle, category: "InitIOSSession")
    
    ///The ActivityModelExtension name for oslog class
    static let activityModelExtension = OSLog(subsystem: bundle, category: "ActivityModelExtension")
    
    ///The ActivityCloudService name for oslog class
    static let activityCloudService = OSLog(subsystem: bundle, category: "ActivityCloudService")
    
}
