import Foundation

struct TokenExchangeParams: Encodable {
  let code: String
  let mobile = true
}

struct TokenExchangeResponse: Decodable {
  var accessToken: String
  var expiresIn: Int
  var refreshToken: String?
  var scopes: [String]
  var tokenType: String

  enum CodingKeys: String, CodingKey {
    case accessToken = "access_token"
    case expiresIn = "expires_in"
    case refreshToken = "refresh_token"
    case scopes = "scope"
    case tokenType = "token_type"
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    accessToken = try values.decode(String.self, forKey: .accessToken)
    expiresIn = try values.decode(Int.self, forKey: .expiresIn)
    refreshToken = try values.decodeIfPresent(
      String.self,
      forKey: .refreshToken
    )
    tokenType = try values.decode(String.self, forKey: .tokenType)
    scopes = try values.decode(String.self, forKey: .scopes)
      .components(separatedBy: " ")
  }
}
