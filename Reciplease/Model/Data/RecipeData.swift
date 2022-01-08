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

extension Recipe {
    func getTime() -> String {
        guard var time = self.totalTime else { return "⎯" }
        if time == 0 { return "⎯" }
        if time < 60 { return "\(time)min" }
        var result = 0
        while time >= 60 {
            time -= 60
            result += 1
        }
        return "\(result)h"
    }

    func getScore() -> String {
        guard let score = self.yield else { return "⎯"}
        var result = Double(score)
        let units = ["", "k", "M", "Md"]
        var index = 0
        while result >= 1000 {
            result /= 1000
            index += 1
        }
        return "\(result.toString(1))\(units[index])"
    }
}
