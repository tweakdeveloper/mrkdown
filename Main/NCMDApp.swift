import SwiftUI

import AlamofireNetworkActivityIndicator

@main
struct NCMDApp: App {
  func main() {
    NetworkActivityIndicatorManager.shared.isEnabled = true
  }

  var body: some Scene {
    WindowGroup {
      MainView()
    }
  }
}
