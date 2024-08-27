import Foundation

extension URL {
  func getQueryItem(_ param: String) -> String? {
    let components = URLComponents(url: self, resolvingAgainstBaseURL: false)!
    guard let queryItems = components.queryItems else {
      return nil
    }
    guard let indexOfParam = queryItems.firstIndex(where: { item in
      return item.name == param
    }) else {
      return nil
    }
    return queryItems[indexOfParam].value
  }
}
