import Foundation
import Alamofire

class RecipeService {

    static let shared = RecipeService()
    private init() {}

    // MARK: - Parameters

    /// More : https://developer.edamam.com/edamam-docs-recipe-api
    private static let baseURL = "https://api.edamam.com/api/recipes/v2"

    private enum UrlQueryItems: String {
        /// Pass this items's raw values to build a valid URL
        case type
        case input = "q"
        case idToken = "app_id"
        case keyToken = "app_key"

        var defaultValue: String? {
            /// Pass this values as default values for items
            switch self {
            case .type: return "public"
            case .input: return nil
            case .idToken: return Token.app_id
            case .keyToken: return Token.app_key
            }
        }
    }

    struct Params: Encodable {
        let type: String
        let q: String
        let app_id: String
        let app_key: String
    }

    static func getRecipes(
        /// - parameter ingredients: an array of ingredients
        /// - returns :
        madeWith ingredients: [String],
        completion: @escaping (Swift.Result<RecipeResult, ApiError>) -> Void) {

            guard var urlComponents = URLComponents(string: baseURL) else {
                completion(.failure(.url))
                return
            }

            urlComponents.queryItems = [
                URLQueryItem(name: UrlQueryItems.type.rawValue, value: UrlQueryItems.type.defaultValue),
                URLQueryItem(name: UrlQueryItems.input.rawValue, value: ingredients.joined(separator: ",")),
                URLQueryItem(name: UrlQueryItems.idToken.rawValue, value: UrlQueryItems.idToken.defaultValue),
                URLQueryItem(name: UrlQueryItems.keyToken.rawValue, value: UrlQueryItems.keyToken.defaultValue)
            ]

            guard let components = urlComponents.string, let url = URL(string: components) else {
                completion(.failure(.query))
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "GET"

            getResponse(fromRequest: request) { result in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let string):
                    guard let data = string.data(using: .utf8),
                        let recipes = try? JSONDecoder().decode(RecipeResult.self, from: data) else {
                        completion(.failure(.decoding))
                        return
                    }
                    completion(.success(recipes))
                }
            }
        }

    private static func getResponse(
        fromRequest request:URLRequest,
        completion: @escaping (Swift.Result<String, ApiError>) -> Void) {
            Alamofire.request(request.description).responseString { response in
                        if let JSON = response.result.value {
                            completion(.success(JSON))
                        }
                completion(.failure(.server))
                    }
        }

}




