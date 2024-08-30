import Foundation

enum SignInError: Error {
  case codeNotFound
  case stateDidNotMatch(String, String)
  case stateNotFound
}
