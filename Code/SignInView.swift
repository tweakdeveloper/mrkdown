import SwiftUI

import AuthenticationServices

struct SignInView: View {
  @Environment(\.webAuthenticationSession) private var webAuthenticationSession
  
  var body: some View {
    Button("sign in to tumblr") {
      Task {
        let state = UUID().uuidString
        let authURL = buildAuthURL(withState: state)
        do {
          let urlWithToken = try await webAuthenticationSession.authenticate(
            using: authURL,
            callbackURLScheme: "mrkdown",
            preferredBrowserSession: .shared
          )
          let urlComponents = URLComponents(
            url: urlWithToken,
            resolvingAgainstBaseURL: false
          )!
          guard let stateParamIndex = urlComponents.queryItems?.firstIndex(
            where: { param in
              return param.name == "state"
            }
          ) else {
            print("redirect did not include state param")
            return
          }
          let receivedState = urlComponents.queryItems?[stateParamIndex].value
          if(receivedState == state) {
            print("login succeeded")
          } else {
            throw SignInError.stateDidNotMatch(receivedState ?? "unknown")
          }
        } catch SignInError.stateDidNotMatch(let receivedState) {
          print("state did not match: got \(receivedState)")
        } catch {
          print("something bad happened: \(error)")
        }
      }
    }
  }
}

struct SignInView_Previews: PreviewProvider {
  static var previews: some View {
    SignInView()
  }
}
