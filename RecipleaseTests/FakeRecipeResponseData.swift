import Foundation

class FakeRecipeResponseData: FakeResponseData {
    // MARK: - Fake Data
    static var dataWeatherOK: Data? {
        let bundle = Bundle(for: FakeRecipeResponseData.self)
        let url = bundle.url(forResource: "RecipeData", withExtension: "json")!
        let data = try? Data(contentsOf: url)
        return data
    }

    static var dataIconOK: Data? {
        let bundle = Bundle(for: FakeRecipeResponseData.self)
        let url = bundle.url(forResource: "Icon", withExtension: "png")!
        let data = try? Data(contentsOf: url)
        return data
    }
}
