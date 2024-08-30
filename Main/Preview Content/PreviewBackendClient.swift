import Foundation

struct PreviewBackendClient: BackendClient {
  func exchangeCode(_: String) async throws -> String {
    return "token"
  }
}
