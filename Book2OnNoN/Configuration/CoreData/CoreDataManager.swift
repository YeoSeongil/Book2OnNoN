//
//  CoreDataManager.swift
//  Book2OnNoN
//
//  Created by 여성일 on 4/1/24.
//

import Foundation
import CoreData


class CoreDataManager {
    
    enum CoreDataResult {
       case success
       case failure(Error)
   }
    
    static let shared: CoreDataManager = CoreDataManager()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Book2OnNoNData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("error \(error)")
            }
        })
        return container
    }()
    
    private var managedObjectContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init() {  _ = persistentContainer }
    
    func saveData(completion: @escaping (CoreDataResult) -> Void) {
        guard managedObjectContext.hasChanges else {
            completion(.success)
            return
        }
        do {
            try managedObjectContext.save()
            completion(.success)
        } catch {
            completion(.failure(error))
        }
    }
    
    func insertData<T: NSManagedObject>(_ type: T.Type) -> T? {
        guard let entityName = T.entity().name else {
            return nil
        }
        return NSEntityDescription.insertNewObject(forEntityName: entityName, into: managedObjectContext) as? T
    }
    
    func deleteData(_ object: NSManagedObject) {
        managedObjectContext.delete(object)
    }
    
    func fetchData<T: NSManagedObject>(_ type: T.Type,  predicate: NSPredicate? = nil) -> [T]? {
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: type))
        
        if let predicate = predicate {
            fetchRequest.predicate = predicate
        }
        
        do {
            let result = try managedObjectContext.fetch(fetchRequest)
            return result
        } catch {
            print("fetch Error")
            return nil
        }
    }
}
