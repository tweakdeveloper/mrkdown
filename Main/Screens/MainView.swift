import SwiftUI

import AuthenticationServices

struct MainView: View {
  @Environment(\.webAuthenticationSession)
  private var webAuthenticationSession: WebAuthenticationSession

  @EnvironmentObject var model: MainModel

  @State private var editorFocused = false

  enum SignInError: Error {
    case codeNotReceived
    case stateDidNotMatch(String)
    case stateNotReceived
  }

  func buildAuthURL(withState state: String) -> URL {
    var baseURL = URL(string: "https://mrkdown.slottedspoon.dev/init_auth_flow")!
    baseURL.append(queryItems: [
      URLQueryItem(name: "state", value: state),
      URLQueryItem(name: "mobile", value: "true")
    ])
    return baseURL
  }

  func performLogin() async {
    let state = UUID().uuidString
    let authURL = buildAuthURL(withState: state)
    do {
      let urlWithToken = try await webAuthenticationSession.authenticate(
        using: authURL,
        callbackURLScheme: "mrkdown",
        preferredBrowserSession: .shared
      )
      guard let receivedState = urlWithToken.getQueryParam("state") else {
        throw SignInError.stateNotReceived
      }
      if receivedState == state {
        guard let code = urlWithToken.getQueryParam("code") else {
          throw SignInError.codeNotReceived
        }
        await model.authCodeReceived(code: code)
      } else {
        throw SignInError.stateDidNotMatch(receivedState)
      }
    } catch SignInError.codeNotReceived {
      print("code not received!")
    } catch SignInError.stateDidNotMatch(let receivedState) {
      print("state did not match: got \(receivedState)")
    } catch SignInError.stateNotReceived {
      print("state not received!")
    } catch {
      print("something bad happened: \(error)")
    }
  }

  var body: some View {
    NavigationStack {
      GeometryReader { geometry in
        ScrollView {
          NCMDEditor(text: $model.postText, focused: $editorFocused)
            .environment(\.mainWindowSize, geometry.size)
        }
      }
      .alert(
        Text("Submit post without previewing?"),
        isPresented: $model.shouldShowSubmitConfirmation
      ) {
        Button("No", role: .cancel, action: model.showPreview)
        Button("Yes", role: .destructive) {
          model.submitPost(shouldOverrideConfirmation: true)
        }
      } message: {
        Text(
          "You haven't yet previewed your latest modifications to the " +
          "post. Are you sure you want to submit the post?"
        )
      }
      .apply { view in
        if #available(iOS 17, *) {
          view.onChange(of: model.shouldLogUserIn) {
            if model.shouldLogUserIn {
              Task {
                await performLogin()
              }
            }
          }
        } else {
          view.onChange(of: model.shouldLogUserIn) { oldVal in
            let shouldLogUserIn = !oldVal
            if shouldLogUserIn {
              Task {
                await performLogin()
              }
            }
          }
        }
      }
      .navigationTitle("Create a Post")
      .onTapGesture {
        editorFocused = true
      }
      .padding(.horizontal)
      .sheet(isPresented: $model.isPreviewing) {
        NavigationStack {
          PreviewPostView(post: model.postText)
        }
      }
      .toolbar {
        ToolbarItemGroup(placement: .bottomBar) {
          Spacer()
          Button(
            "Preview Post",
            systemImage: "doc",
            action: model.showPreview
          )
        }
        ToolbarItemGroup(placement: .topBarTrailing) {
          Menu("More Options", systemImage: "ellipsis.rectangle") {
            NavigationLink {
              AboutView()
            } label: {
              Label("About mrkdown", systemImage: "info")
            }
          }
          Button(
            "Submit Post",
            systemImage: "paperplane",
            action: model.submitPost
          )
        }
      }
    }
  }
}

#Preview("Main Screen") {
  MainView()
    .environmentObject(MainModel())
}
