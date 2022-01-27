import Foundation
import CoreData

class CoreDataController {

    static let shared = CoreDataController()
    private init() {}

    private var stack = CoreDataStack.init(.persistent)

    init(_ storageType: CoreDataStorage) {
        self.stack = CoreDataStack.init(storageType)
    }

    let defaultTotalTime: Int64 = 1
    let defaultYield: Int64 = 0

    func add(_ recipe: Recipe) throws -> Void {
        let context = stack.context
        let newRecipe = RecipeFavorite(context: context)
        newRecipe.image             = recipe.image
        newRecipe.ingredientLines   = recipe.ingredientLines
        newRecipe.label             = recipe.label
        newRecipe.timestamp         = Date()
        newRecipe.totalTime         = recipe.totalTime ?? defaultTotalTime
        newRecipe.url               = recipe.url
        newRecipe.yield             = recipe.yield ?? defaultYield
        do { try stack.saveContext() }
        catch let error as NSError { throw error }
    }

    func get(
        recipeNamed name: String = "",
        ascending: Bool = false) throws -> [Recipe] {
            let request = RecipeFavorite.fetchRequest()
            if name.count > 0 {
                request.predicate = NSPredicate(format: "label CONTAINS[cd] %@", name)
            }
            request.sortDescriptors = [
                NSSortDescriptor(key: "timestamp", ascending: ascending)
            ]
            return try stack.context.fetch(request).map( {$0.toRecipe() })
        }

    func isFavorite(_ recipe: Recipe) throws -> Bool {
        guard let url = recipe.url else { return false }
        let request = RecipeFavorite.fetchRequest()
        request.predicate = NSPredicate(format: "url == %@", "\(url)")
        return try !stack.context.fetch(request).isEmpty
    }

    func delete(_ recipe: Recipe) throws -> Void {
        let request = RecipeFavorite.fetchRequest()
        if let url = recipe.url {
            request.predicate = NSPredicate(format: "url = %@", "\(url)")
            let result = try stack.context.fetch(request)
            for object in result { stack.context.delete(object)}
            try stack.saveContext()
        }
    }

}
