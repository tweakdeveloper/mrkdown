import XCTest

final class NCMDBackendClientTests: XCTestCase {
  private static let urlBase = "https://mrkdown.slottedspoon.dev"

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
