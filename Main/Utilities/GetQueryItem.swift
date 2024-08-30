import Foundation

extension URL {
  func getQueryItem(_ queryItem: String) -> String? {
    let components = URLComponents(url: self, resolvingAgainstBaseURL: false)
    guard let queryItems = components?.queryItems else {
      return nil
    }
    if let item = queryItems.first(where: { $0.name == queryItem }) {
      return item.value
    } else {
      return nil
    }
  }
}
