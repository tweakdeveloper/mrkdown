import Foundation

struct NCMDBackendClient: BackendClient {
  private static let baseURL = "https://mrkdown.slottedspoon.dev"

  private let decoder = JSONDecoder()
  private let encoder = JSONEncoder()
  private let session: URLSession

  init(session: URLSession = URLSession.shared) {
    self.session = session
  }

  static func buildSignInURL(withState state: String) -> URL {
    var url = URL(string: "\(baseURL)/init_auth_flow")!
    let queryItems = [
      URLQueryItem(name: "state", value: state),
      URLQueryItem(name: "mobile", value: "true")
    ]
    url.append(queryItems: queryItems)
    return url
  }

  func exchangeCode(_ code: String) async throws -> String {
    let url = URL(string: "\(Self.baseURL)/exchange_code")!
    var req = URLRequest(url: url)
    req.httpMethod = "POST"
    let reqBody = ExchangeCodeRequest(code: code)
    req.httpBody = try encoder.encode(reqBody)
    req.setValue("application/json", forHTTPHeaderField: "Content-Type")
    let (responseData, _) = try await session.data(for: req)
    let apiResponse = try decoder.decode(
      ExchangeCodeResponse.self,
      from: responseData
    )
    return apiResponse.accessToken
  }
}

extension NCMDBackendClient {
  private struct ExchangeCodeRequest: Encodable {
    let code: String
    let mobile = "true"
  }

  private struct ExchangeCodeResponse: Decodable {
    let accessToken: String
    let expiresIn: Int
    let refreshToken: String?
    let scopes: [String]
    let tokenType: String

    init(from decoder: Decoder) throws {
      let values = try decoder.container(keyedBy: CodingKeys.self)
      accessToken = try values.decode(String.self, forKey: .accessToken)
      expiresIn = try values.decode(Int.self, forKey: .expiresIn)
      refreshToken = try values.decode(String?.self, forKey: .refreshToken)
      tokenType = try values.decode(String.self, forKey: .tokenType)

      scopes = try values
        .decode(String.self, forKey: .scopes)
        .components(separatedBy: " ")
    }

    // swiftlint:disable:next nesting
    enum CodingKeys: String, CodingKey {
      case accessToken = "access_token"
      case expiresIn = "expires_in"
      case refreshToken = "refresh_token"
      case scopes = "scope"
      case tokenType = "token_type"
    }
  }
}
