import Foundation
import CoreData

open class CoreDataStack {

    public enum StorageType {
      case persistent, inMemory
    }

    // MARK: - Variable

    let persistentContainer: NSPersistentContainer

    // MARK: - Initializer

    public init(_ storageType: StorageType = .persistent) {
        self.persistentContainer = NSPersistentContainer(name: "Reciplease")
        if storageType == .inMemory {
            let description = NSPersistentStoreDescription()
            description.url = URL(fileURLWithPath: "/dev/null")
            self.persistentContainer.persistentStoreDescriptions = [description]
        }
        self.persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    // MARK: - Core Data stack

    public var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    public func saveContext() throws {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
}
