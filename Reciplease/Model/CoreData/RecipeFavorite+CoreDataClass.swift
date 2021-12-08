import Foundation
import CoreData

public class RecipeFavorite: NSManagedObject {}

extension RecipeFavorite {
    func toRecipe() -> Recipe {
        let recipe = Recipe(
            label: self.label,
            image: self.image,
            url: self.url,
            yield: self.yield,
            ingredientLines: self.ingredientLines,
            totalTime: self.totalTime)
        return recipe
    }
}
