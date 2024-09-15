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

  func testExchangeCodeWithSuccessfulResponse() async throws {
    let accessToken = "test_token"
    let expiresIn = 3600
    let tokenType = "bearer"
    let scopes = "basic write"
    let jsonString = """
{
  "access_token": "\(accessToken)",
  "expires_in": \(expiresIn),
  "token_type": "\(tokenType)",
  "refresh_token": null,
  "scope": "\(scopes)"
}
"""
    let data = jsonString.data(using: .utf8)

    NCMDMockURLProtocol.requestHandler = { request in
      let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
      return (response, data)
    }

    let returnedToken = try await backendClient.exchangeCode("test_code")
    XCTAssertEqual(returnedToken, accessToken, "NCMDBackendClient did not convert access token correctly")
  }
}
