import Foundation

struct CreatePostResponse: Decodable {
  var meta: Meta
  var response: [String: String]
}
