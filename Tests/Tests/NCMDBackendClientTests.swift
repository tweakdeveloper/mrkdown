import XCTest

final class NCMDBackendClientTests: XCTestCase {
  private static let urlBase = "https://mrkdown.slottedspoon.dev"

  var backendClient: NCMDBackendClient!

  override func setUp() {
    let configuration = URLSessionConfiguration.default
    configuration.protocolClasses = [NCMDMockURLProtocol.self]
    let session = URLSession(configuration: configuration)

    backendClient = NCMDBackendClient(session: session)
  }
}

// MARK: static func tests
extension NCMDBackendClientTests {
  func testAuthURLIsCorrect() {
    let correctURLString = Self.urlBase + "/init_auth_flow?state=test&mobile=true"
    let correctURL = URL(string: correctURLString)
    let actualURL = NCMDBackendClient.buildSignInURL(withState: "test")
    XCTAssertEqual(
      correctURL,
      actualURL,
      "generated URL did not match expected URL"
    )
  }
}

// MARK: exchangeCode() tests
extension NCMDBackendClientTests {
  private func getTestData() throws -> Data {
    let appBundle = Bundle(for: Self.self)
    let jsonURL = appBundle.url(forResource: "exchangeCodePayload", withExtension: "json")!
    return try Data(contentsOf: jsonURL)
  }

  func testExchangeCodeRetrievesToken() async throws {
    let data = try getTestData()

    NCMDMockURLProtocol.requestHandler = { request in
      let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
      return (response, data)
    }

    let returnedToken = try await backendClient.exchangeCode("test_code")
    XCTAssertEqual(returnedToken, "test_token", "NCMDBackendClient did not convert access token correctly")
  }
}
