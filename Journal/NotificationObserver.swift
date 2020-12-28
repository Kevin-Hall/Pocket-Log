//
//  NotificationObserver.swift
//  Journal
//
//  Created by Kevin Hall on 6/15/18.
//  Copyright © 2018 Kevin Hall. All rights reserved.
//

import Foundation
import CloudCore
import CoreData
import os.log

class CloudCoreDelegateHandler: CloudCoreDelegate {
    
    func willSyncFromCloud() {
        os_log("🔁 Started fetching from iCloud", log: OSLog.default, type: .debug)
    }
    
    func didSyncFromCloud() {
        os_log("✅ Finishing fetching from iCloud", log: OSLog.default, type: .debug)
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Entries")

        UserDefaults.standard.setValue(Date(), forKey: "last_sync")

        
        do {
            entries = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
//        let fr = NSFetchRequest<Entries>(entityName: "Entries")
//        let sort = NSSortDescriptor(key: #keyPath(Entries.date), ascending: false)
//        fr.sortDescriptors = [sort]
//        
//        do {
//            entriesThisMonth = try context.fetch(fr)
//        } catch {
//            print("Cannot fetch Expenses")
//        }

        DispatchQueue.main.async {
            gridCollectionView.reloadData()
        }
        
        //
        
        //NotificationCenter.default.post(name: .reloadCoreData, object: nil)
    }
    
    func willSyncToCloud() {
        os_log("💾 Started saving to iCloud", log: OSLog.default, type: .debug)
    }
    
    func didSyncToCloud() {
        os_log("✅ Finished saving to iCloud", log: OSLog.default, type: .debug)
        
    }
    
    func error(error: Error, module: Module?) {
        print("⚠️ CloudCore error detected in module \(String(describing: module)): \(error)")
    }
    
}
