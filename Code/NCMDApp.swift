import SwiftUI

@main
struct NCMDApp: App {
  @StateObject private var mainModel = MainModel()

  var body: some Scene {
    WindowGroup {
      MainView()
        .environmentObject(mainModel)
    }
  }
}
