//   let reciplease = try? newJSONDecoder().decode(Reciplease.self, from: jsonData)

import Foundation
import CoreData

// MARK: - Recipe Data
struct RecipeResult: Decodable {
    let hits: [Hit]?
}

// MARK: - Recipe Data
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
