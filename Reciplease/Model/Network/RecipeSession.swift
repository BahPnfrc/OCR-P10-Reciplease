import Foundation
import Alamofire

class RecipeSession {

    var nextHref: String? {
        didSet {
            print(nextHref ?? "No \(String.init(describing: self))")
        }
    }

    static let shared = RecipeSession()
    private init() {}

    private var recipeSession = URLSession.shared.configuration
    private var imageSession = URLSession.shared.configuration
    private var recipeNextSession = URLSession.shared.configuration

    // MARK: - Parameters

    /// More : https://developer.edamam.com/edamam-docs-recipe-api
    private let baseURL = "https://api.edamam.com/api/recipes/v2"

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

            AF.request(baseURL, method: .get, parameters: params).response { response in
                guard response.response?.statusCode == 200,
                      response.error == nil,
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
                    for hit in hits {
                        if let recipe = hit.recipe { recipes.append(recipe)}
                    }
                }
                self.nextHref = recipeData.links?.next?.href ?? nil
                completion(.success(recipes))
            }
        }

    func getNextRecipes(completion: @escaping (Swift.Result<[Recipe], ApiError>) -> Void) {
        guard let href = self.nextHref else {
            completion(.failure(.other(error: "No previous Href")))
            return
        }

        self.nextHref = nil
        AF.request(href, method: .get).response { response in
            guard response.response?.statusCode == 200,
                  response.error == nil,
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
                for hit in hits {
                    if let recipe = hit.recipe { recipes.append(recipe)}
                }
            }

            self.nextHref = recipeData.links?.next?.href
            completion(.success(recipes))

        }
    }

    func getPicture(
        fromURL url: String?,
        completion: @escaping(Swift.Result<UIImage, ApiError>) -> Void) {
            guard let url = url else { return }
            AF.request(url, method: .get).response { response in
                guard response.response?.statusCode == 200,
                    response.error == nil,
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




