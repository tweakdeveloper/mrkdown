import SwiftUI

protocol BackendClient {
  func exchangeCode(_: String) async throws -> String
}

private struct BackendClientKey: EnvironmentKey {
  static let defaultValue: BackendClient = NCMDBackendClient()
}

extension EnvironmentValues {
  var backendClient: BackendClient {
    get { self[BackendClientKey.self] }
    set { self[BackendClientKey.self] = newValue }
  }
}
