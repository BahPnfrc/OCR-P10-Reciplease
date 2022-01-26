import XCTest
import Foundation
import CoreData
@testable import Reciplease

class RecipeCoreDataTests: XCTestCase {

    // MARK: - CoreData
    var controller: CoreDataController!

    // MARK: - Object

    var randomRecipe: Recipe = {
        return Recipe(
            label: randomString(),
            image: randomString(),
            url: randomString(),
            yield: randomInt(),
            ingredientLines: randomArray(),
            totalTime: randomInt())
    }()

    private static func randomString(_ length: Int = 10) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }

    private static func randomArray(_ lines: Int = 3) -> [String] {
        var array = [String]()
        for _ in 0...abs(lines) - 1 { array.append(randomString()) }
        return array
    }

    private static func randomInt(_ from: Int64 = 1, _ to: Int64 = 1000) -> Int64 {
        return Int64.random(in: from..<to)
    }

    // MARK: - Initializing

    override func setUpWithError() throws {
        try super.setUpWithError()
        controller = CoreDataController(.inMemory)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        controller = nil
    }

    // MARK: - Tests

    func testGivenAnyNumberOfSavedRecipes_whenSavingAnother_thenThisNumberGrowByOne() throws {
        let recipe = randomRecipe
        try controller.add(recipe)
        let result = try? controller.get()
        let savedRecipe = result?.first
        XCTAssertEqual(result?.count, 1)
        XCTAssertTrue(savedRecipe == recipe)
    }

    func testGivenRecipeIsNotSaved_whenSavingRecipe_thenRecipeIsFavorite() throws {
        let testRecipe = randomRecipe
        try controller.add(testRecipe)
        XCTAssertTrue(controller.isFavorite(testRecipe))
    }

}
