import Foundation
import Alamofire

class RecipeSession {

    static let shared = RecipeSession()
    private init() {}

    private var recipeSession = URLSession(configuration: .default)
    private var imageSession = URLSession(configuration: .default)
    init(recipeSession: URLSession) {
        self.recipeSession = recipeSession
    }
    init(imageSession: URLSession) {
        self.imageSession = imageSession
    }

    // MARK: - Parameters

    /// More : https://developer.edamam.com/edamam-docs-recipe-api
    private let baseURL = "https://api.edamam.com/api/recipes/v2"

    /// Pass this items's raw values to build a valid URL
    private enum UrlQueryItems: String {
        case type
        case input = "q"
        case idToken = "app_id"
        case keyToken = "app_key"

        /// Pass this values as default values for items
        var defaultValue: String? {
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

    func getRecipes(
        /// - parameter ingredients: an array of ingredients
        /// - returns :
        madeWith ingredients: [String],
        completion: @escaping (Swift.Result<[Recipe], ApiError>) -> Void) {

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
                          let recipeData = try? JSONDecoder().decode(RecipeData.self, from: data) else {
                              completion(.failure(.decoding))
                              return
                          }
                    var recipes = [Recipe]()
                    if let hits = recipeData.hits {
                        for hit in hits {
                            if let recipe = hit.recipe { recipes.append(recipe)}
                        }
                    }
                    completion(.success(recipes))
                }
            }
        }

    private func getResponse(
        fromRequest request:URLRequest,
        completion: @escaping (Swift.Result<String, ApiError>) -> Void) {
            Alamofire.request(request.description).responseString { response in
                if let JSON = response.result.value {
                    completion(.success(JSON))
                }
                completion(.failure(.server))
            }
        }

    func getPicture(
        fromURL url: String?,
        completion: @escaping(Swift.Result<UIImage, ApiError>) -> Void) {
            guard let url = url else { return }
            Alamofire.request(url).response { (result) in
                guard result.error == nil, let data = result.data else {
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



