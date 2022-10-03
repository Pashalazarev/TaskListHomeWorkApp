//
//  StorageManager.swift
//  TaskList
//
//  Created by Pavel Lazarev Macbook on 03.10.2022.
//

import Foundation
import CoreData

class StorageManger {
    static let shared = StorageManger()
    
    let context: NSManagedObjectContext
    
    //MARK: - Core Data Stack
    
    var persistentContainer: NSPersistentContainer = { // точка входа в базу данных
        let container = NSPersistentContainer(name: "TaskList")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
        
    }()
    
    init() {
        context = persistentContainer.viewContext
    }
    
    // MARK: - Core Data Saving support
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchData(completion: ([Task]) -> Void) {
        let fetchRequest = Task.fetchRequest()
        
        do {
            let taskList = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func save(_ taskName: String, completion: (Task) -> Void) {
        let task = Task(context: context)
        task.title = taskName
        completion(task)
        
        saveContext()
    }
}
