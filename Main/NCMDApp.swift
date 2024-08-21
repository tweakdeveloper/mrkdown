import SwiftUI

import AlamofireNetworkActivityIndicator

@main
struct NCMDApp: App {
  @StateObject private var mainModel = MainModel()

  func main() {
    NetworkActivityIndicatorManager.shared.isEnabled = true
  }

  var body: some Scene {
    WindowGroup {
      MainView()
        .environmentObject(mainModel)
    }
  }
}
