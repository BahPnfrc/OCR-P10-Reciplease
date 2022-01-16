import Foundation
import Mocker

public final class MockedData {
    public static var recipeDataOK: Data = try! Data(
        contentsOf: Bundle(for: MockedData.self)
            .url(forResource: "RecipeData", withExtension: "json")!)

    public static var recipeNextDataOK: Data = try! Data(
        contentsOf: Bundle(for: MockedData.self)
        .url(forResource: "RecipeNextData", withExtension: "json")!)

    public static var recipeImageOK: Data = try! Data(
        contentsOf: Bundle(for: MockedData.self)
        .url(forResource: "RecipeImage", withExtension: "jpg")!)

    public static let recipeDataKO = "someData".data(using: .utf8)!
    public static let recipeNextDataKO = "someNextData".data(using: .utf8)!
    public static let recipeImageKO = "someImage".data(using: .utf8)!
}
