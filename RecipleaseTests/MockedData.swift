import Foundation
import Mocker
@testable import Reciplease

public final class MockedData {

    // MARK: - URL

    public static let recipeDataURL = URL(string: RecipeSession.baseURL)!
    public static let recipeNextDataURL = URL(string: "https://api.edamam.com/api/recipes/v2?q=Chicken&app_key=250a1351d346d00d5d307e3947f647f8&_cont=CHcVQBtNNQphDmgVQntAEX4BYldtBAAGQGBEBmsbalx6BAEEUXlSVmQVYlV3VgIDQjRGBDcSY1Z3VwoARjMWCmUVZAcgBlEVLnlSVSBMPkd5BgMbUSYRVTdgMgksRlpSAAcRXTVGcV84SU4%3D&type=public&app_id=6957d86d")!
    public static let recipeImageURL = URL(string: "https://www.edamam.com/web-img/e42/e42f9119813e890af34c259785ae1cfb.jpg")!

    // MARK: - DATA OK

    public static var recipeDataOK: Data = try! Data(
        contentsOf: Bundle(for: MockedData.self)
            .url(forResource: "RecipeData", withExtension: "json")!)

    public static var recipeNextDataOK: Data = try! Data(
        contentsOf: Bundle(for: MockedData.self)
        .url(forResource: "RecipeNextData", withExtension: "json")!)

    public static var recipeImageOK: Data = try! Data(
        contentsOf: Bundle(for: MockedData.self)
        .url(forResource: "RecipeImage", withExtension: "jpeg")!)

    // MARK: - DATA KO

    public static let recipeDataKO = "someData".data(using: .utf8)!
    public static let recipeNextDataKO = "someNextData".data(using: .utf8)!
    public static let recipeImageKO = "someImage".data(using: .utf8)!
}
