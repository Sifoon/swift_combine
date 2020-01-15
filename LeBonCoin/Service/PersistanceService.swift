//
//  PersistanceService.swift
//  LeBonCoin
//
//  Created by Seif Nasri on 11/01/2020.
//  Copyright © 2020 Seif Nasri. All rights reserved.
//

import Foundation
import CoreData


class PersistanceService {
    
    static var context: NSManagedObjectContext?{
          return persistentContainer.viewContext
      }
      
    init() {
    }
    
    static var childContext: NSManagedObjectContext?{
        let childContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        childContext.parent = context
        return childContext
    }

        static var persistentContainer: NSPersistentContainer = {
            /*
             The persistent container for the application. This implementation
             creates and returns a container, having loaded the store for the
             application to it. This property is optional since there are legitimate
             error conditions that could cause the creation of the store to fail.
            */
            let container = NSPersistentContainer(name: "LeBonCoin")
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                     
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
            container.viewContext.retainsRegisteredObjects = true
            return container
        }()

        // MARK: - Core Data Saving support

    static func saveContext (context : NSManagedObjectContext){
//            let context = persistentContainer.viewContext
            if context.hasChanges {
                do {
                    try context.save()
                    print("saved")
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    print(nserror)
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
    
    func fetchTemperaturesWithCity(city : String) -> [Temperatures]?{
        do {
            let fetchRequest : NSFetchRequest<Temperatures> = Temperatures.fetchRequestTemperatures()
            fetchRequest.predicate = NSPredicate(format: "location.city == %@", city)
            return try PersistanceService.context!.fetch(fetchRequest)
            }
        catch {
            return nil
            }
    }
    
    
    
    func fetchAllTemperatures() -> [Temperatures]?{

        do {
                let fetchRequest : NSFetchRequest<Temperatures> = Temperatures.fetchRequestTemperatures()
                return try PersistanceService.context!.fetch(fetchRequest)
            }
        catch
            {
                return nil
            }
    }

}
