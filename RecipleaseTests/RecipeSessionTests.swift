import XCTest
import Alamofire
import Mocker
@testable import Reciplease

class RecipeSessionTests: XCTestCase {

    private let timeout = 10.0
    var configuration = URLSessionConfiguration.af.default
    var mockedSessionManager: Session!

    /* setUpWithError() or run this for each function :
    let configuration = URLSessionConfiguration.af.default
    configuration.protocolClasses = [MockingURLProtocol.self]
    let sessionManager = Alamofire.Session(configuration: configuration) */
    override func setUpWithError() throws {
        configuration.protocolClasses = [MockingURLProtocol.self]
        mockedSessionManager = Alamofire.Session(configuration: configuration)
    }

    // MARK: - GET RECIPE

    func testGivenInvalidResponse_whenRequestingRecipe_thenServerErrorIsReturned() {

        let mock = Mock(
            url: MockedData.recipeDataURL,
            ignoreQuery: true,
            dataType: .json,
            statusCode: 404,
            data: [.get: MockedData.recipeDataOK])
        mock.register()

        let expectation = expectation(description: "OK")
        let session = RecipeSession.init(session: self.mockedSessionManager)
        session.getRecipes(madeWith: [""]) { response in
            switch response {
            case .failure:
                expectation.fulfill()
            default:
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: timeout)
    }

    func testGivenInvalidData_whenRequestingRecipe_thenDecodingErrorIsReturned() {

        let mock = Mock(
            url: MockedData.recipeDataURL,
            ignoreQuery: true,
            dataType: .json,
            statusCode: 200,
            data: [.get: MockedData.recipeDataKO])
        mock.register()

        let expectation = expectation(description: "OK")
        let session = RecipeSession.init(session: self.mockedSessionManager)
        session.getRecipes(madeWith: [""]) { response in
            switch response {
            case .failure:
                expectation.fulfill()
            default:
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: timeout)
    }

    func testGivenValidData_whenRequestingRecipe_thenRecipeArrayIsReturned() {

        let mock = Mock(
            url: MockedData.recipeDataURL,
            ignoreQuery: true,
            dataType: .json,
            statusCode: 200,
            data: [.get: MockedData.recipeDataOK])
        mock.register()

        let expectation = expectation(description: "OK")
        let session = RecipeSession.init(session: self.mockedSessionManager)
        session.getRecipes(madeWith: [""]) { response in
            switch response {
            case .success:
                expectation.fulfill()
            default:
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: timeout)
    }

    // MARK: - GET NEXT RECIPE

    func testGivenInvalidResponse_whenRequestingNextRecipe_thenServerErrorIsReturned() {

        let mock = Mock(
            url: MockedData.recipeNextDataURL,
            ignoreQuery: true,
            dataType: .json,
            statusCode: 404,
            data: [.get: MockedData.recipeNextDataKO])
        mock.register()

        let expectation = expectation(description: "OK")
        let session = RecipeSession.init(session: self.mockedSessionManager)
        session.getNextRecipes(nextHref: mock.url.description) { response in
            switch response {
            case .failure:
                expectation.fulfill()
            default:
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: timeout)
    }

    func testGivenInvalidData_whenRequestingNextRecipe_thenDecodingErrorIsReturned() {

        let mock = Mock(
            url: MockedData.recipeNextDataURL,
            ignoreQuery: true,
            dataType: .json,
            statusCode: 200,
            data: [.get: MockedData.recipeNextDataKO])
        mock.register()

        let expectation = expectation(description: "OK")
        let session = RecipeSession.init(session: self.mockedSessionManager)
        session.getNextRecipes(nextHref: mock.url.description) { response in
            switch response {
            case .failure:
                expectation.fulfill()
            default:
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: timeout)
    }

    func testGivenValidData_whenRequestingNextRecipe_thenRecipeArrayIsReturned() {

        let mock = Mock(
            url: MockedData.recipeNextDataURL, ignoreQuery: true,
            dataType: .json, statusCode: 200,
            data: [.get: MockedData.recipeNextDataOK])
        mock.register()

        let expectation = expectation(description: "OK")
        let session = RecipeSession.init(session: self.mockedSessionManager)
        session.getNextRecipes(nextHref: mock.url.description) { response in
            switch response {
            case .success:
                expectation.fulfill()
            default:
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: timeout)
    }

    // MARK: - GET IMAGE

    func testGivenInvalidResponse_whenRequestingImage_thenServerErrorIsReturned() {

        let mock = Mock(
            url: MockedData.recipeImageURL,
            ignoreQuery: true,
            dataType: .json,
            statusCode: 404,
            data: [.get: MockedData.recipeImageKO])
        mock.register()

        let expectation = expectation(description: "OK")
        let session = RecipeSession.init(session: self.mockedSessionManager)
        session.getPicture(fromURL: mock.url.description) { response in
            switch response {
            case .failure:
                expectation.fulfill()
            default:
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: timeout)
    }

    func testGivenInvalidData_whenRequestingImage_thenDecodingErrorIsReturned() {

        let mock = Mock(
            url: MockedData.recipeImageURL,
            ignoreQuery: true,
            dataType: .json,
            statusCode: 200,
            data: [.get: MockedData.recipeImageKO])
        mock.register()

        let expectation = expectation(description: "OK")
        let session = RecipeSession.init(session: self.mockedSessionManager)
        session.getPicture(fromURL: mock.url.description) { response in
            switch response {
            case .failure:
                expectation.fulfill()
            default:
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: timeout)
    }

    func testGivenValidData_whenRequestingImage_thenImageIsReturned() {

        let mock = Mock(
            url: MockedData.recipeImageURL,
            ignoreQuery: true,
            dataType: .json,
            statusCode: 200,
            data: [.get: MockedData.recipeImageOK])
        mock.register()

        let expectation = expectation(description: "OK")
        let session = RecipeSession.init(session: self.mockedSessionManager)
        session.getPicture(fromURL: mock.url.description) { response in
            switch response {
            case .success:
                expectation.fulfill()
            default:
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: timeout)
    }
}
