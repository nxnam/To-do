//
//  CoreDataManager.swift
//  Todo-App
//
//  Created by Nguyễn Xuân Nam on 9/18/19.
//  Copyright © 2019 Nguyễn Xuân Nam. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager {
    
    static let sharedManager = CoreDataManager()
    
    func insertData(entityName: String, forKey: String, value: String) {
        let AppDel: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context:NSManagedObjectContext = AppDel.persistentContainer.viewContext
        
        let newLists = NSEntityDescription.insertNewObject(forEntityName: "\(entityName)", into: context)
        
        newLists.setValue(value, forKey: "\(forKey)")
        do {
            try context.save()
        } catch {
            print("Error")
        }
    }
    
    func fetchData(array: inout [String], entityName: String, forKey: String) {
        let AppDel: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context:NSManagedObjectContext = AppDel.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "\(entityName)")
        request.returnsObjectsAsFaults = true
        
        do {
            let results = try context.fetch(request)
            
            for data in results as! [NSManagedObject]{
                let a = data.value(forKey: "\(forKey)") as! String
                
                array.insert(a, at: 0)
            }
            
        } catch {
            print("Error")
        }
    }
    
    func updateData(array: inout [String], value: String, index: Int, entityName: String, forKey: String) {
        let AppDel: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context:NSManagedObjectContext = AppDel.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "\(entityName)")
        request.returnsObjectsAsFaults = true
        
        do {
            var results = try context.fetch(request)
            
            let objManager = results[index] as! NSManagedObject
            
            objManager.setValue(value, forKey: "\(forKey)")
            
            do {
                try context.save()
            } catch {
                
            }
            
        } catch {
            print("Error")
        }
    }
    
    func deleteData(entityName: String, index: Int) {
        let AppDel: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context:NSManagedObjectContext = AppDel.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "\(entityName)")
        request.returnsObjectsAsFaults = true
        
        do {
            let results = try context.fetch(request)
            
            context.delete(results[index] as! NSManagedObject)
            
            do {
                try context.save()
            } catch {
                
            }
        } catch {
            print("Error")
        }
        
    }
}
