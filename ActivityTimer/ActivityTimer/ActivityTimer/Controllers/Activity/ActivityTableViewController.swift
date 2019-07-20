//
//  ActivityTableViewController.swift
//  ActivityTimer
//
//  Created by Krzysztof Maraszkiewicz on 24/05/2019.
//  Copyright © 2019 Krzysztof Maraszkiewicz. All rights reserved.
//

import os.log
import WatchConnectivity
import UIKit

///The ActivityTableViewController class
class ActivityTableViewController: UITableViewController {
    
    //MARK: properties
    ///The activities model items
    var activities = [ActivityModel]()
    
    ///The OSLog type name
    private static let osLogName = OSLog.activityTableViewController
    
    ///The ActivityService instance
    private var activityService: ActivityService?
    
    ///The apple watch session
    private let sesssion: WCSession? = WCSession.isSupported() ? WCSession.default : nil
    
    private var loadingBarViewController: LoadingBarViewController?
    
    ///The apple watch session after checked valida state or nil if state of session is invalid
    private var validateReachableSession: WCSession?
    {
        if let sess = self.sesssion, sess.isPaired && sess.isWatchAppInstalled {
            return self.sesssion
        }
        
        return nil
    }
    
    ///The view did load event
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        self.activityService = ActivityService.shared(appDelegate.persistentContainer.viewContext as NSManagedObjectContextProtocol, onError:showAlert(error:))
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        sesssion?.delegate = self
        sesssion?.activate()
        
        fetchData()
    }
    
    // MARK: - Table view data source
    ///Selects max number of selection in table
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    ///Sets table items count
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    ///Fills data in table
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityTableViewCell", for: indexPath) as? ActivityTableViewCell else {
            
            os_log("Could not found valid ActivityTableViewCell type to convert data to table cell", log: ActivityTableViewController.osLogName, type: .fault)
            fatalError("Occours error while tring to find proper table cell type")
        }
        
        let activity = activities[indexPath.row]
        
        cell.nameLabel.text = activity.name
        
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            self.toggleLoadingBar(visible: true) {
                self.deleteActivity(indexPath: indexPath)
            }
        }
    }
    
    // MARK: - Navigation
    
    /// In a storyboard-based application, you will often want to do a little preparation before navigation
    ///
    /// - Parameters:
    ///   - segue: The UIStoryboardSegue
    ///   - sender: The sender
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        print("1")
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        switch (segue.identifier ?? "") {
        case "AddActivity":
            print("2")
            prepareAddActivityForm(for: segue)
            
        case "EditActivity":
            prepareEditActivityForm(for: segue, sender: sender)
            
        default:
            os_log("Destination %s not implemented",
                   log: ActivityTableViewController.osLogName,
                   type: .error,
                   segue.destination)
            fatalError("Segue destination not found")
        }
        
    }
    
    ///Event triggers after response comming from another view
    @IBAction func redeirectFromForm(sender: UIStoryboardSegue) {
        
        toggleLoadingBar(visible: true) {
            print("4")
            if let activityFormViewController = sender.source as? ActivityFormViewController,
                let activity = activityFormViewController.activity {
                
                var workType = ""
                
                do {
                    if let index = self.tableView.indexPathForSelectedRow {
                        
                        workType = "updating"
                        
                        try self.updateActivity(activity: activity, index: index)
                        
                    } else {
                        
                        workType = "saving"
                        print("5")
                        self.addActivity(activity: activity)
                    }
                } catch ServiceError.noItemsFound {
                    return
                } catch ServiceError.databaseError {
                    self.showAlert(title: "Error", withMessage: "Error with \(workType) data occours")
                } catch {
                    self.showAlert(title: "Error", withMessage: "Unknow exception occours")
                }
            }
        }
    }
    
    //MARK: HELPER METHODS
    
    private var finish = false
    /// Presents loading bar view controller
    private func toggleLoadingBar(visible: Bool, onViewCompletion: (() -> Void)?) {
        
        DispatchQueue.main.async {
            
            if self.loadingBarViewController == nil {
                self.loadingBarViewController = (self.storyboard?.instantiateViewController(withIdentifier: "LoadingBarViewController") as! LoadingBarViewController)
                
                self.loadingBarViewController!.modalPresentationStyle = .fullScreen
            }
            
            if visible && self.loadingBarViewController != nil {
                print("3")
                self.present(self.loadingBarViewController!, animated: false, completion: {
                    onViewCompletion?()
                })
            } else if !visible {
                print("9")
                
                self.loadingBarViewController?.close()
                self.loadingBarViewController = nil
            }
        }
    }
    
    /// Show alert
    ///
    /// - Parameter error: The Error message
    private func showAlert(error: String?) {
        self.showAlert(title: "An error occured", withMessage: String(describing: error))
    }
    
    ///Show alert
    ///- parameter title: The alert title
    ///- parameter withMessage: The alert message
    private func showAlert (title: String, withMessage: String) {
        
        let action = UIAlertController(title: title, message: withMessage, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        action.addAction(okAction)
        
        present(action, animated: true)
        
    }
    
    ///Fetch activies models data
    private func fetchData () {
        do {
            activities = try activityService!.getAll()
            tableView.reloadData()
        } catch ServiceError.databaseError {
            showAlert(title: "Error", withMessage: "Error with saving data occours")
        } catch {
            showAlert(title: "Error", withMessage: "Unknow exception occours")
        }
    }
    
    //MARK: Navigation helper methods
    
    /// Prepare before navigates to add activity form
    ///
    /// - Parameter segue: The UIStoryboardSegue
    private func prepareAddActivityForm(for segue: UIStoryboardSegue) {
        os_log("Adding activity with %{PUBLIC}@ destination",
               log: ActivityTableViewController.osLogName,
               type: .info,
               segue.destination)
    }
    
    
    /// Prepare before navigates to update activity form
    ///
    /// - Parameters:
    ///   - segue: The UIStoryboardSegue
    ///   - sender: The sender
    private func prepareEditActivityForm(for segue: UIStoryboardSegue, sender: Any?) {
        guard let activityFormViewController = segue.destination as? ActivityFormViewController else {
            os_log("Invalid convertion from segue.destination to ActivityFormViewController", log: ActivityTableViewController.osLogName, type: .error)
            
            fatalError("Errour occours while tring to navigate to edit form")
            
        }
        
        guard let selectedCell = sender as? ActivityTableViewCell else {
            os_log("Invalid convertion from sender to ActivityTableViewCell", log: ActivityTableViewController.osLogName, type: .error)
            
            fatalError("Errour occours while tring to navigate to edit form")
        }
        
        guard let index = tableView.indexPath(for: selectedCell) else {
            os_log("Invalid convertion from sender to ActivityTableViewCell", log: ActivityTableViewController.osLogName, type: .error)
            
            fatalError("Errour occours while tring to navigate to edit form")
        }
        
        activityFormViewController.activity = activities[index.row]
    }
    
    //MARK: Activity crud methods
    
    /// Adds activity to storages
    ///
    /// - Parameter activity: The activity model data
    private func addActivity (activity: ActivityModel) {
        print("6")
        self.activityService!.save(activityModel: activity, onSuccess: {
            addedActivity in
            print("7")
            WCSession.initIOSSession(session: self.sesssion, sessionAction: { (validreachableSession) in
                
                let activityModelToSend = ActivityModel(id: addedActivity.id, name: addedActivity.name, operationType: ActivityOperationType.added)
                
                validreachableSession.sendMessageData(NSKeyedArchiver.encodeActivity(activityModelToSend, forKey: "activity"), replyHandler: nil, errorHandler: nil)
                
            })
            
            self.activities.append(addedActivity)
            
            DispatchQueue.main.async {
                print("8")
                self.tableView.reloadData()
                self.toggleLoadingBar(visible: false, onViewCompletion: nil)
            }
            
            
        })
    }
    
    /// Update activity from storages
    ///
    /// - Parameters:
    ///   - activity: The activity data
    ///   - index: The index path informations
    /// - Throws: Throws error when somthing went wrong while updating activity on starages
    private func updateActivity(activity: ActivityModel, index: IndexPath) throws {
        WCSession.initIOSSession(session: self.sesssion, sessionAction: { (validreachableSession) in
            
            let activityModelToSend = ActivityModel(id: activities[index.row].id, name: activity.name, operationType: ActivityOperationType.updated)
            
            validreachableSession.sendMessageData(NSKeyedArchiver.encodeActivity(activityModelToSend, forKey: "activity"), replyHandler: nil, errorHandler: nil)
            
        })
        
        try activityService!.update(id: activities[index.row].id, activityModel: activity)
        activities[index.row].name = activity.name
        tableView.reloadRows(at: [index], with: .fade)
    }
    
    /// Deletes activity from storages
    ///
    /// - Parameter indexPath: The index path of activity on activity models list
    private func deleteActivity(indexPath: IndexPath) {
        
        WCSession.initIOSSession(session: self.sesssion, sessionAction: { (validreachableSession) in
            
            let activityModelToSend = ActivityModel(id: self.activities[indexPath.row].id, name: self.activities[indexPath.row].name, operationType: ActivityOperationType.deleted)
            validreachableSession.sendMessageData(NSKeyedArchiver.encodeActivity(activityModelToSend, forKey: "activity"), replyHandler: nil, errorHandler: nil)
            
        })
        
        self.activityService?.delete(activityModel: self.activities[indexPath.row]) {
            DispatchQueue.main.async {
                self.activities.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
            self.toggleLoadingBar(visible: false, onViewCompletion: nil)
        }
    }
}

///The ActivityTableViewController extension with WCSessionDelegate helpers methods
extension ActivityTableViewController: WCSessionDelegate {
    
    ///The event triggers when apple watch send request
    func session(_ session: WCSession, didReceiveMessageData messageData: Data, replyHandler: @escaping (Data) -> Void) {
        
        replyHandler(NSKeyedArchiver.encodeActivity(self.activities, forKey: "activities"))
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("activationDidCompleteWith activationState:\(activationState) error:\(String(describing: error))")
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("sessionDidBecomeInactive: \(session)")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("sessionDidDeactivate: \(session)")
        
        self.sesssion?.activate()
    }
    
}
