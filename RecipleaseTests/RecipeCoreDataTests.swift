import XCTest
import Foundation
@testable import Reciplease

class RecipeCoreDataTests: XCTestCase {

    func getCoreDataElements() -> Int {
        return try! CoreDataController.shared.get().count
    }
    func getNewTestRecipe() -> Recipe {
        return Recipe(label: "testRecipeLabel + \(Int.random(in: 0...100))", image: "testRecipeImage", url: "testRecipeUrl", yield: 1, ingredientLines: ["testRecipeIngredient"], totalTime: 1)
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        let recipes = try CoreDataController.shared.get(recipeNamed: "testRecipeLabel", ascending: true)
        for recipe in recipes {
            try CoreDataController.shared.delete(recipe)
        }
    }

    func testGivenAnyNumberOfSavedRecipes_whenSavingAnother_thenThisNumberGrowByOne() throws {
        let beforeRecipeCount = getCoreDataElements()
        let testRecipe = getNewTestRecipe()
        try CoreDataController.shared.add(testRecipe)
        let afterRecipeCount = getCoreDataElements()
        XCTAssert(afterRecipeCount == beforeRecipeCount + 1)
    }

    func testGivenAnyNumberOfSavedRecipes_whenSavingAndDeletingANother_thenNumberIsEqual() throws {
        let beforeRecipeCount = getCoreDataElements()
        let testRecipe = getNewTestRecipe()
        try CoreDataController.shared.add(testRecipe)
        try CoreDataController.shared.delete(testRecipe)
        let afterRecipeCount = getCoreDataElements()
        XCTAssert(afterRecipeCount == beforeRecipeCount)
    }

    func testGivenRecipeIsNotSaved_whenSavingRecipe_thenRecipeIsFavorite() throws {
        let testRecipe = getNewTestRecipe()
        XCTAssertFalse(CoreDataController.shared.isFavorite(testRecipe))
        try CoreDataController.shared.add(testRecipe)
        XCTAssertTrue(CoreDataController.shared.isFavorite(testRecipe))
    }

}
