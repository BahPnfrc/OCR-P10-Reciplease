import XCTest
import Foundation
import CoreData
@testable import Reciplease

public extension NSManagedObject {
    /// Help void "warning: Multiple NSEntityDescriptions claim the NSManagedObject subclass"
    convenience init(usedContext: NSManagedObjectContext) {
        let name = String(describing: type(of: self))
        let entity = NSEntityDescription.entity(forEntityName: name, in: usedContext)!
        self.init(entity: entity, insertInto: usedContext)
    }
}

class RecipeCoreDataTests: XCTestCase {

    /// https://www.donnywals.com/setting-up-a-core-data-store-for-unit-tests/
    /// https://medium.com/tiendeo-tech/ios-how-to-unit-test-core-data-eb4a754f2603
    /// https://www.raywenderlich.com/11349416-unit-testing-core-data-in-ios

    // MARK: - Properties

    var controller: CoreDataController!

    // MARK: - Mocked Data

    private func randomRecipe() -> Recipe {
        return Recipe(
            label: randomString(),
            image: randomString(),
            url: randomString(),
            yield: randomInt(),
            ingredientLines: randomArray(),
            totalTime: randomInt())
    }

    private func randomRecipe(named name: String) -> Recipe {
        return Recipe(
            label: name,
            image: randomString(),
            url: randomString(),
            yield: randomInt(),
            ingredientLines: randomArray(),
            totalTime: randomInt())
    }

    private func noInt64Recipe() -> Recipe {
        return Recipe(
            label: randomString(),
            image: randomString(),
            url: randomString(),
            yield: nil,
            ingredientLines: randomArray(),
            totalTime: nil)
    }

    private func noUrlRecipe() -> Recipe {
        return Recipe(
            label: randomString(),
            image: randomString(),
            url: nil,
            yield: randomInt(),
            ingredientLines: randomArray(),
            totalTime: randomInt())
    }

    private func randomString(_ length: Int = 10) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }

    private func randomArray(_ lines: Int = 3) -> [String] {
        var array = [String]()
        for _ in 0...abs(lines) - 1 { array.append(randomString()) }
        return array
    }

    private func randomInt(_ from: Int64 = 1, _ to: Int64 = 1000) -> Int64 {
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

    // MARK: - Add Tests

    func testGivenAnyUncompleteRecipe_whenSavingAndRetreivingIt_thenDefaultValuesWereUsed() throws {
        // Given
        let recipe = noInt64Recipe()
        // When
        try controller.add(recipe)
        let result = try? controller.get()
        XCTAssertNotNil(result)
        // Then
        let savedRecipe = result?.first
        XCTAssertEqual(savedRecipe?.totalTime, controller.defaultTotalTime)
        XCTAssertEqual(savedRecipe?.yield, controller.defaultYield)
    }

    func testGivenAnyCompleteRecipe_whenSavingAndRetreivingIt_thenRecipeIsStillTheSame() throws {
        // Given
        let recipe = randomRecipe()
        // When
        try? controller.add(recipe)
        let result = try? controller.get()
        XCTAssertNotNil(result)
        // Then
        let savedRecipe = result?.first
        XCTAssertEqual(result?.count, 1)
        XCTAssertTrue(savedRecipe == recipe)
    }

    // MARK: - Get Tests

    func testGivenManyRecipes_whenSearchingWithKey_thenMatchingOnesAreReturned() {
        // Given
        let recipes = [
            randomRecipe(named: "ABCD"),
            randomRecipe(named: "CDEF"),
            randomRecipe(named: "EFGH")]
        for recipe in recipes {
            try? controller.add(recipe)
        }
        // When
        let abResults = try? controller.get(recipeNamed: "AB")
        let cdResults = try? controller.get(recipeNamed: "CD")
        let xyResults = try? controller.get(recipeNamed: "XY")
        // Then
        XCTAssertEqual(xyResults?.count, 0)
        XCTAssertEqual(abResults?.count, 1)
        XCTAssertEqual(cdResults?.count, 2)
    }

    func testGivenManyRecipes_whenSearchingWithNoKey_thenAllAreReturned() {
        // Given
        let recipes = [
            randomRecipe(named: "ABCD"),
            randomRecipe(named: "CDEF"),
            randomRecipe(named: "EFGH")]
        for recipe in recipes {
            try? controller.add(recipe)
        }
        // When
        let results = try? controller.get()
        XCTAssertNotNil(results)
        // Then
        XCTAssertEqual(results?.count, recipes.count)
    }

    func testGivenManyRecipes_whenNoneMatchesKey_thenEmptyArrayIsReturned() {
        // Given
        let recipes = [
            randomRecipe(named: "ABCD"),
            randomRecipe(named: "CDEF"),
            randomRecipe(named: "EFGH")]
        for recipe in recipes {
            try? controller.add(recipe)
        }
        // When
        let results = try? controller.get(recipeNamed: "XY")
        XCTAssertNotNil(results)
        // Then
        XCTAssertEqual(results?.count, 0)
    }

    // MARK: - IsFavorite Tests

    func testGivenRecipeIsNotSaved_whenSaved_thenRecipeIsFavorite() throws {
        // Given
        let recipe = randomRecipe()
        // When
        try? controller.add(recipe)
        // Then
        let result = try controller.isFavorite(recipe)
        XCTAssertTrue(result)
    }

    func testGivenRecipeHasNoURL_whenSaved_thenRecipeIsNotFavorite() throws {
        // Given
        let recipe = noUrlRecipe()
        // When
        try? controller.add(recipe)
        let result = try controller.isFavorite(recipe)
        // Then
        XCTAssertFalse(result)
    }

    func testGivenAnyRecipe_whenNotSaved_thenRecipeIsNotFavorite() throws {
        // Given
        let recipe = randomRecipe()
        // When
        let result = try controller.isFavorite(recipe)
        // Then
        XCTAssertFalse(result)
    }

    // MARK: - Delete Tests

    func testGivenRecipeIsSaved_whenDeleting_thenRecipeIsNotFavorite() throws {
        // Given
        let recipe = randomRecipe()
        try controller.add(recipe)
        XCTAssertTrue(try controller.isFavorite(recipe))
        // When
        try controller.delete(recipe)
        let result = try controller.isFavorite(recipe)
        // Then
        XCTAssertFalse(result)
    }

    // MARK: - Error Tests

    func testGivenRecipeIsSaved_whenSavingAgain_thenErrorIsThrown() throws {
        // Given
        let recipe = randomRecipe()
        try controller.add(recipe)
        XCTAssertTrue(try controller.isFavorite(recipe))
        // When
        XCTAssertThrowsError(try controller.add(recipe)) { error in
            // Then
            XCTAssertEqual(error as! CoreDataError, CoreDataError.saving)
        }
    }
}
