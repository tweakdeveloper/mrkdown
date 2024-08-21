import Foundation

func buildAuthURL(withState state: String) -> URL {
  var baseURL = URL(string: "https://mrkdown.slottedspoon.dev/init_auth_flow")!
  baseURL.append(queryItems: [
    URLQueryItem(name: "state", value: state),
    URLQueryItem(name: "mobile", value: "true")
  ])
  return baseURL
}

enum SignInError: Error {
  case stateDidNotMatch(String)
}
