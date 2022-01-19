import Foundation
import Alamofire

class RecipeSession {

    private(set) static var nextHref: String? {
        didSet {
            print(nextHref ?? "No nextHref")
        }
    }

    static let shared = RecipeSession()
    private init() {}


    private var sessionManager = Alamofire.Session(configuration: URLSessionConfiguration.default)

    init(session: Session) {
        self.sessionManager = session
    }

    // MARK: - Parameters

    /// More : https://developer.edamam.com/edamam-docs-recipe-api
    static let baseURL = "https://api.edamam.com/api/recipes/v2"

    struct Params: Codable {
        let type: String
        let input: String
        let idToken: String
        let keyToken: String

        enum CodingKeys: String, CodingKey {
            case type
            case input = "q"
            case idToken = "app_id"
            case keyToken = "app_key"
        }
    }

    func getRecipes(
        madeWith ingredients: [String],
        completion: @escaping (Swift.Result<[Recipe], ApiError>) -> Void) {

            let params = Params(
                type: "public",
                input: ingredients.joined(separator: ","),
                idToken: Token.app_id,
                keyToken: Token.app_key)

            sessionManager.request(
                RecipeSession.baseURL,
                method: .get,
                parameters: params)
                .response { response in
                    guard response.error == nil,
                          response.response?.statusCode == 200,
                          let data = response.data else {
                              completion(.failure(.server))
                              return
                          }
                    guard let recipeData = try? JSONDecoder().decode(RecipeData.self, from: data) else {
                        completion(.failure(.decoding))
                        return
                    }
                    var recipes = [Recipe]()
                    if let hits = recipeData.hits {
                        recipes = hits.compactMap( {$0.recipe} )
                    }
                    RecipeSession.nextHref = recipeData.links?.next?.href ?? nil
                    completion(.success(recipes))
                }
        }

    func getNextRecipes(
        nextHref url: String,
        completion: @escaping (Swift.Result<[Recipe], ApiError>) -> Void) {
            sessionManager.request(
                url,
                method: .get)
                .response { response in
                    guard response.error == nil,
                          response.response?.statusCode == 200,
                          let data = response.data else {
                              RecipeSession.nextHref = nil
                              completion(.failure(.server))
                              return
                          }

                    guard let recipeData = try? JSONDecoder().decode(RecipeData.self, from: data) else {
                        RecipeSession.nextHref = nil
                        completion(.failure(.decoding))
                        return
                    }

                    var recipes = [Recipe]()
                    if let hits = recipeData.hits {
                        recipes = hits.compactMap( {$0.recipe} )
                    }
                    RecipeSession.nextHref = recipeData.links?.next?.href
                    completion(.success(recipes))
                }
        }

    func getPicture(
        fromURL url: String?,
        completion: @escaping(Swift.Result<UIImage, ApiError>) -> Void) {
            guard let url = url else { return }
            sessionManager.request(
                url,
                method: .get)
                .response { response in
                    guard response.error == nil,
                          response.response?.statusCode == 200,
                          let data = response.data else {
                              completion(.failure(.server))
                              return
                          }
                    guard let image = UIImage(data: data, scale: 1) else {
                        completion(.failure(.decoding))
                        return
                    }
                    completion(.success(image))
                }
        }
}




