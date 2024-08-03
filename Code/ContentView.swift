import SwiftUI

import AuthenticationServices

struct ContentView: View {
  @Environment(\.webAuthenticationSession) private var webAuthenticationSession
  
  var body: some View {
    Button("sign in to tumblr") {
      Task {
        let authURL = buildAuthURL()
        do {
          let urlWithToken = try await webAuthenticationSession.authenticate(
            using: authURL,
            callbackURLScheme: "mrkdown",
            preferredBrowserSession: .shared
          )
          print(urlWithToken.absoluteString)
        } catch {
          print("something bad happened: \(error)")
        }
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
