//
//  Manager.swift
//  coreDataDemoApp
//
//  Created by Никита Микрюков on 03.10.2020.
//  Copyright © 2020 Никита Микрюков. All rights reserved.
//


import CoreData

class StorageManager {
    
    static let shared = StorageManager()
    
    // MARK: - Core Data stack
    private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "coreDataDemoApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init() {}
    
    // MARK: - Public Methods
    func fetchData() -> [Task] {
        
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        do {
            return try viewContext.fetch(fetchRequest)
        } catch let error {
            print(error)
            return []
        }
        
    }
    
    func save(_ taskName: String, completion: (Task) -> Void) {
        
        //получаем описание сущности и передаем имя сущности в иницализатор и контекст
        guard let entityDescription = NSEntityDescription
            .entity(forEntityName: "Task", in: viewContext) else { return }
        //кастим обьект до типа таск
        guard let task = NSManagedObject(entity: entityDescription, insertInto: viewContext) as? Task else { return }
        //присваем значене которое введет пользователь
        task.name = taskName
        // работаем внутри оперативной памати, и чтобы изменения применить нужно взвать метод save
        do {
            try viewContext.save()
        } catch let error {
            print(error.localizedDescription)
        }
        completion(task)
        saveContext()
    }
    func delete(_ task: Task) {
        viewContext.delete(task)
        saveContext()
    }
    
    func edit(_ task: Task, edit: String) {
        task.name = edit
        saveContext()
        
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
    
}
