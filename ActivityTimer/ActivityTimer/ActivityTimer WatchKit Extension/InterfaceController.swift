//
//  InterfaceController.swift
//  ActivityTimer WatchKit Extension
//
//  Created by Krzysztof Maraszkiewicz on 23/05/2019.
//  Copyright © 2019 Krzysztof Maraszkiewicz. All rights reserved.
//

import Foundation
import WatchOSShared
import os.log
import WatchKit
import WatchConnectivity

///The ActivityInterfaceController class
class ActivityInterfaceController: WKInterfaceController {
    
    //MARK: Outlets
    
    ///The table outlet
    @IBOutlet weak var table: WKInterfaceTable!
    
    ///The load data button outlet
    @IBOutlet weak var loadDataButton: WKInterfaceButton!
    
    //MARK: private properties
    
    ///The OSLog type name
    private static let osLogName = OSLog.activityInterfaceController
    
    ///The activities items
    private var activities = [ActivityModel]()
    
    ///The ios app session instance
    private let session: WCSession? = WCSession.isSupported() ? WCSession.default : nil
    
    ///The awake event
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    }
    
    ///The will activte event
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        sendMessageAnmdGetResponseFromIPhone()
        
        session?.delegate = self
        session?.activate()
    }
    
    ///The did deactivate event
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    ///The load data action after click `loadDataButton` button
    ///Fetch current items from ios app
    @IBAction func loadDataAction() {
        sendMessageAnmdGetResponseFromIPhone()
    }
    
    ///Refreshes data from ios apps
    private func refreshTable () {
        
        if self.activities.isEmpty || self.activities.count == 0 {
            toggleLoadDataBtnVisible(true)
        } else {
            toggleLoadDataBtnVisible(false)
        }
        
        self.table.setNumberOfRows(activities.count, withRowType: "ActivityRowController")
        
        let rowCount = self.table.numberOfRows
        
        for i in 0..<rowCount {
            let row = self.table.rowController(at: i) as! ActivityRowController
            
            row.nameLbl.setText(activities[i].name)
        }
    }
    
    ///Toggles enabled and hidden status of loadData button
    ///- parameter isHidden: The enabled and hidden status of loadData button
    private func toggleLoadDataBtnVisible(_ isHidden: Bool) {
        loadDataButton.setEnabled(isHidden)
        loadDataButton.setHidden(!isHidden)
    }
}

///The `ActivityInterfaceController` class extension
///With event method of WCSessionDelegate class
extension ActivityInterfaceController : WCSessionDelegate {
 
    ///Triggers when session did activate
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("activationDidCompleteWith activationState:\(activationState) error:\(String(describing: error))")
    }
    
    ///Triggers after ios app sent request
    ///- parameter session: The WCSession instance
    ///- parameter messageData: The data response from ios app
    func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
        do {
            
            try NSKeyedUnarchiver.decodeActivity(messageData, forKey: "activity") { (activityModelFromResponse: ActivityModel) in
                
                if let operationType = activityModelFromResponse.operationType {
                    
                    switch operationType {
                        case ActivityOperationType.added:
                           
                            print(activityModelFromResponse.id ?? "n/a")
                            self.activities.append(activityModelFromResponse)
                            self.refreshTable()
                            break
                        
                        case ActivityOperationType.updated:
                            
                            let activitiesModel = self.activities.filter({ (activityModel) -> Bool in
                                return activityModel.id == activityModelFromResponse.id
                            })
                            
                            if let activityModel = activitiesModel.first {
                                activityModel.name = activityModelFromResponse.name
                                
                                self.refreshTable()
                            }
                            
                            break
                        
                    case .deleted:
                        
                        for a in self.activities {
                            print(a.id ?? "n/a")
                        }
                        
                        print(activityModelFromResponse.id ?? "n/a")
                        
                        if let activityIdToRemove = self.activities.firstIndex(where: { (activityModel) -> Bool in
                            return activityModel.id == activityModelFromResponse.id
                        }) {
                            self.activities.remove(at: activityIdToRemove)
                            self.refreshTable()
                        }
                        
                        break
                    }
                    
                }
                
                
                
            }
            
            
        } catch let error as NSError {
            os_log("Error occours while tring to get data from IPhone. %{PUBLIC}@. %{PUBLIC}@", log: OSLog.activityInterfaceController, type: .error, error, error.userInfo)
            
            WKAlertHelper.showInfoAlert(title: "Error occours", message: "Error occours while tring to get data from IPhone", usingController: self)
        }
    }
    
    ///Sends the request to ios app
    private func sendMessageAnmdGetResponseFromIPhone() {
        initSession { (validReachableSession) in
            validReachableSession.sendMessageData(Data(), replyHandler: { (data) in
                
                do {
                    
                    try NSKeyedUnarchiver.decodeActivity(data, forKey: "activities", afterDecodeAction: { (activitiesFromResponse: [ActivityModel]) in
                            self.activities = activitiesFromResponse
                            self.refreshTable()})
                    
                } catch let error as NSError {
                    os_log("Error occours while tring to get data from IPhone. %{PUBLIC}@. %{PUBLIC}@", log: OSLog.activityInterfaceController, type: .error, error, error.userInfo)
                    
                    WKAlertHelper.showInfoAlert(title: "Error occours", message: "Error occours while tring to get data from IPhone", usingController: self)
                }
            }, errorHandler: { (err) in
                DispatchQueue.main.async {
                    WKAlertHelper.showInfoAlert(title: "Error occours", message: "Error occours while tring to fetch data from IPhone", usingController: self)
                    
                    os_log("Error occours while watch tring to fetch data from IPhone app. %{PUBLIC}@", log: OSLog.activityInterfaceController, type: .error, "\(err)")
                }
            })
        }
    }
    
    //MARK: The session helpers
    
    ///Initialize session for ios app
    ///- parameter sessionAction: The action triggers when session is in valid state
    private func initSession (sessionAction: (WCSession) -> Void) {
        
            WCSession.initSession(session: self.session, sessionAction: sessionAction) { (errorType) in
            
            os_log("Watch session is not %{PUBLIC}@", log: ActivityInterfaceController.osLogName, type: .error,
                   errorType)
            
            WKAlertHelper.showInfoAlert(title: "Session is on error state", message: "Watch session is not \(errorType)", usingController: self)
            
        }
    }
}
