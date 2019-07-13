//
//  ActivityService.swift
//  ActivityTimer
//
//  Created by Krzysztof Maraszkiewicz on 27/05/2019.
//  Copyright © 2019 Krzysztof Maraszkiewicz. All rights reserved.
//

import CloudKit
import CoreData
import os.log
import UIKit

///The activity service
public class ActivityService {
    
    ///The singlethon of ActivityService class
    private static var sharedCommon: ActivityService?
    
    ///The os_log type name
    private static let osLogName = OSLog.activityService
    
    ///The NSManagedObjectContext instance
    private let managedObjectContext: NSManagedObjectContextProtocol

    ///Instance of activity cloud service
    private var activityCloudService: ActivityCloudServiceProtocol

    ///Action that run when occours errors using activity cloud service
    private var onError: ((String?) -> Void)?
    
    ///The initializer of ActiveService instance
    private init(managedObjectContext: NSManagedObjectContextProtocol, onError: ((Error?) -> Void)? = nil, activityCloudService: ActivityCloudServiceProtocol? = nil) {
        self.managedObjectContext = managedObjectContext
        
        if let onErrorTmp = onError {
            self.onError = onErrorTmp
        }
        
        if activityCloudService == nil {
            self.activityCloudService = ActivityCloudService()
        } else {
            self.activityCloudService = activityCloudService!
        }
    }
    
    ///The singlethon of ActivityService class
    public static func shared(_ managedObjectContext: NSManagedObjectContextProtocol, onError: ((Error?) -> Void)? = nil, activityCloudService: ActivityCloudServiceProtocol? = nil) -> ActivityService {
    
        if ActivityService.sharedCommon == nil || managedObjectContext.isMockingProtocol {
            ActivityService.sharedCommon = ActivityService(managedObjectContext: managedObjectContext)
        }
    
        return ActivityService.sharedCommon!
    }
    
    ///Get all activities
    ///- returns: The ActivityModel array
    public func getAll() throws -> [ActivityModel] {
        
        let fetchPredicate = NSFetchRequest<NSManagedObject>(entityName: "Activity")
        
        do {
            
            let activities = try managedObjectContext.fetch(fetchPredicate)
            
            return activities.toActivityModels()
            
        } catch let error as NSError {
            os_log("Error while saving data to database. %{PUBLIC}@. %{PUBLIC}@", log: ActivityService.osLogName, type: .error, "\(error)", "\(error.userInfo)")
            
            throw ServiceError.databaseError
            
        }
    }
    
    ///Saves activity model to db
    /// - parameter activityModel: The activity model data
    /// - throws: `ServiceError.databaseError` if error occours while saving data
    /// - returns: The ActivityModel array
    public func save(activityModel: ActivityModel) throws -> ActivityModel {

        let entity = NSEntityDescription.entity(forEntityName: "Activity", in: self.managedObjectContext.context)!
        let activity = NSManagedObject(entity: entity, insertInto: self.managedObjectContext.context)
        
        activity.setValue(activityModel.name, forKey: "name")
        
        self.activityCloudService.save(activityModel: activity.toActivityCloudModel(), onSuccess: {
            do {
                
                try self.managedObjectContext.save()
                activity.toActivityModel()
            } catch let error as NSError {
                
                os_log("Error while saving data to database. %{PUBLIC}@. %{PUBLIC}@", log: ActivityService.osLogName, type: .error, "\(error)", "\(error.userInfo)")
                
                self.onError?(String(desc))
            }
        }, onError: { (error) in
            self.onError?(String(desc))
        })
        
    }
    
    ///Updates activity model data
    /// - parameter id: The activity identifier
    /// - parameter activityModel: The activity model data
    /// - Throws: `ServiceError.databaseError` if error occours while updating data
    public func update (id: URL?, activityModel: ActivityModel) throws {
        
        let activity = try findByUrlId(id)
        
        do {
            
            activity.setValue(activityModel.name, forKey: "name")
            
            try managedObjectContext.save()
            
        } catch let error as NSError {
            os_log("Error occours while tring to updating data from CoreData. %{PUBLIC}@. %{PUBLIC}@",
                   log: ActivityService.osLogName,
                   type: .error,
                   "\(error)", "\(error.userInfo)")
            
            throw ServiceError.databaseError
        }
        
    }
    
    ///Deletes activity
    /// - parameter activityModel: The activity model data
    /// - Throws: `ServiceError.databaseError` if error occours while deleting data
    public func delete(activityModel: ActivityModel) throws {
        
        let id = try findByUrlId(activityModel.id)
        
        do {
            managedObjectContext.delete(id)
            
            try managedObjectContext.save()
            
        } catch let error as NSError {
            os_log("Error occours while tring to deleting data from CoreData. %{PUBLIC}@. %{PUBLIC}@",
                   log: ActivityService.osLogName,
                   type: .error,
                   "\(error)", "\(error.userInfo)")
            
            throw ServiceError.databaseError
        }
    }
    
    ///Finds activity by url id
    /// - parameter id: The id of activity model data
    /// - Throws: `ServiceError.databaseError` if error occours while updating data
    /// - returns: The NSManagedObject
    private func findByUrlId (_ id: URL?) throws -> NSManagedObject {
        
        guard let id = id,
            let objectID = managedObjectContext.persistentStoreCoordinatorHelper?.managedObjectID(forURIRepresentation: id) else {
                
                os_log("Error occours while tring to get object id from ActivityModel",
                       log: ActivityService.osLogName,
                       type: .error)
                
                throw ServiceError.noItemsFound
        }
        
        do {
            return try managedObjectContext.existingObject(with: objectID)
            
        } catch let error as NSError {
            os_log("Error occours while tring to fetch data from CoreData by object id. %{PUBLIC}@. %{PUBLIC}@",
                   log: ActivityService.osLogName,
                   type: .error,
                   "\(error)", "\(error.userInfo)")
            
            throw ServiceError.databaseError
        }
    }
}
