import Foundation

// MARK: - Recipe Data
struct RecipeData: Decodable {
    let hits: [Hit]?
}

// MARK: - Hit
struct Hit: Decodable {
    let recipe: Recipe?
}

// MARK: - Recipe
struct Recipe: Decodable {
    let label: String?
    let image: String?
    let url: String?
    let yield: Int64?
    let ingredientLines: [String]?
    let totalTime: Int64?
}

extension Recipe {
    func toFavorite() -> RecipeFavorite {
        let favorite = RecipeFavorite()
        favorite.image             = self.image
        favorite.ingredientLines   = self.ingredientLines
        favorite.label             = self.label
        favorite.timestamp         = Date()
        favorite.totalTime         = self.totalTime ?? 0
        favorite.url               = self.url
        favorite.yield             = self.yield ?? 1
        return favorite
    }

}
