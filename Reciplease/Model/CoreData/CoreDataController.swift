import Foundation
import CoreData

class CoreDataController {

    static let shared = CoreDataController()
    private init() {}

    private let context = AppDelegate.viewContext

    private func saveContext() throws -> Void {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                throw error
            }
        }
    }
}

extension CoreDataController {

    func add(_ recipe: Recipe) throws -> Void {
        let newRecipe = RecipeFavorite(context: context)
        newRecipe.image             = recipe.image
        newRecipe.ingredientLines   = recipe.ingredientLines
        newRecipe.label             = recipe.label
        newRecipe.timestamp         = Date()
        newRecipe.totalTime         = recipe.totalTime ?? 1
        newRecipe.url               = recipe.url
        newRecipe.yield             = recipe.yield ?? 0
        try? saveContext()
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
            do {
                return try context.fetch(request).map( {$0.toRecipe() })
            } catch {
                throw error
            }
        }

    func isFavorite(_ recipe: Recipe) -> Bool {
        guard let url = recipe.url else { return false }
        let request = RecipeFavorite.fetchRequest()
        request.predicate = NSPredicate(format: "url == %@", "\(url)")
        guard let recipes = try? context.fetch(request) else { return false }
        return !recipes.isEmpty
    }

    func delete(_ recipe: Recipe) throws -> Void {
        let request = RecipeFavorite.fetchRequest()
        if let url = recipe.url {
            request.predicate = NSPredicate(format: "url = %@", "\(url)")
            do {
                let result = try context.fetch(request)
                for object in result { context.delete(object)}
                try? saveContext()
            } catch {
                throw error
            }
        }
    }

}
