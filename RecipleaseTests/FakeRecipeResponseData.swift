import Foundation

class FakeRecipeResponseData: FakeResponseData {
    // MARK: - Fake Data
    static var dataRecipeOK: Data? {
        let bundle = Bundle(for: FakeRecipeResponseData.self)
        let url = bundle.url(forResource: "RecipeData", withExtension: "json")!
        let data = try? Data(contentsOf: url)
        return data
    }

    static var dataImageOK: Data? {
        let bundle = Bundle(for: FakeRecipeResponseData.self)
        let url = bundle.url(forResource: "RecipeImage", withExtension: "jpg")!
        let data = try? Data(contentsOf: url)
        return data
    }
}
