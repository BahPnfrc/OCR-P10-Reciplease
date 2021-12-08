import Foundation
import CoreData

class CoreDataController {

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func saveContext() throws -> Void {
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

    func add(_ recipe: RecipeFavorite) {
        let newRecipe = RecipeFavorite(context: context)
        newRecipe.image             = recipe.image
        newRecipe.ingredientLines   = recipe.ingredientLines
        newRecipe.label             = recipe.label
        newRecipe.timestamp         = Date()
        newRecipe.totalTime         = recipe.totalTime
        newRecipe.url               = recipe.url
        newRecipe.yield             = recipe.yield
        try? saveContext()
    }

    func get(
        recipeNamed name: String = "",
        ascending: Bool = false) throws -> [RecipeFavorite] {
            let request = RecipeFavorite.fetchRequest()
            if name.count > 0 {
                request.predicate = NSPredicate(format: "label CONTAINS[cd] %@", name)
            }
            request.sortDescriptors = [
                NSSortDescriptor(key: "timestamp", ascending: ascending)
            ]
            var result = [RecipeFavorite]()
            do {
                let fetchResults = try context.fetch(request)
                for fetchResult in fetchResults { result.append(fetchResult) }
                return result
            } catch {
                throw error
            }
        }

    func alreadyExist(_ recipe: RecipeFavorite) -> Bool {
        guard let url = recipe.url else { return false }
        let request = RecipeFavorite.fetchRequest()
        request.predicate = NSPredicate(format: "url == %@", "\(url)")
        guard let recipes = try? context.fetch(request) else { return false }
        return !recipes.isEmpty
    }

    func delete(_ recipe: RecipeFavorite) throws -> Void {
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
