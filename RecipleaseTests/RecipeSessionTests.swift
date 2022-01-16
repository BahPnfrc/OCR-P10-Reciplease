import XCTest
import Alamofire
import Mocker
@testable import Reciplease

class RecipeSessionTests: XCTestCase {

    private let timeout = 5.0
    var configuration = URLSessionConfiguration.af.default
    var sessionManager: Session!

    /// setUpWithError() or run this for each function :
    //  let configuration = URLSessionConfiguration.af.default
    //  configuration.protocolClasses = [MockingURLProtocol.self]
    //  let sessionManager = Alamofire.Session(configuration: configuration)
    override func setUpWithError() throws {
        configuration.protocolClasses = [MockingURLProtocol.self]
        sessionManager = Alamofire.Session(configuration: configuration)
    }

    func testGivenWeatherServiceIsCalled_whenSuccess_thenRequiredValuesAreNotNil() {

        let mockUrl = URL(string: "someURL")!
        let mockData = MockedData.recipeDataOK
        let mockExpectation = expectation(description: "Request should finish")

        let mock = Mock(
            url: mockUrl,
            dataType: .json,
            statusCode: 200,
            data: [.get: mockData])
        mock.register()

        sessionManager
            .request(mockUrl)
            .responseDecodable(of: RecipeData.self) { response in
            XCTAssertNil(response.error)
            XCTAssertNotNil(response.value)
            XCTAssertNotNil(response.value?.hits)
            mockExpectation.fulfill()
            }.resume()
        wait(for: [mockExpectation], timeout: timeout)
    }
}
