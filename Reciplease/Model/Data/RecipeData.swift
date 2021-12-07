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
    let yield: Int?
    let ingredientLines: [String]?
    let totalTime: Int?
}
