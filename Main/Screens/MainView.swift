import SwiftUI

import AuthenticationServices
import Combine

struct MainView: View {
  @Environment(\.webAuthenticationSession) private var webAuthenticationSession

  @Environment(\.backendClient) private var backendClient

  @StateObject private var model = ViewModel()

  private func performSignIn() {
    let state = UUID().uuidString
    let signInURL = NCMDBackendClient.buildSignInURL(withState: state)
    Task {
      do {
        let urlWithCode = try await webAuthenticationSession.authenticate(
          using: signInURL,
          callbackURLScheme: "mrkdown",
          preferredBrowserSession: .shared
        )
        guard let receivedState = urlWithCode.getQueryItem("state") else {
          throw SignInError.stateNotFound
        }
        if receivedState != state {
          throw SignInError.stateDidNotMatch(state, receivedState)
        }
        guard let code = urlWithCode.getQueryItem("code") else {
          throw SignInError.codeNotFound
        }
        let accessToken = try await backendClient.exchangeCode(code)
        model.setAccessToken(accessToken)
      } catch let error as SignInError {
        let baseMessage = "sign in error happened: "
        switch error {
        case .codeNotFound:
          print(baseMessage + "code not found")
        case .stateDidNotMatch(let expected, let actual):
          print(
            baseMessage +
            "state did not match (expected \"\(expected)\", got \"\(actual))\""
          )
        case .stateNotFound:
          print(baseMessage + "state not found")
        }
      } catch {
        print("??? happened: \(error)")
      }
    }
  }

  var body: some View {
    NavigationStack {
      ScrollView {
        NCMDEditor(text: $model.postText, focused: $model.editorFocused)
      }
      .alert(
        Text("Submit post without previewing?"),
        isPresented: $model.shouldShowSubmitConfirmation
      ) {
        Button("No", role: .cancel, action: model.showPreview)
        Button("Yes", role: .destructive) {
          model.submitPost(shouldOverridePreviewRequirement: true)
        }
      } message: {
        Text(
          "You haven't yet previewed your latest modifications to the " +
          "post. Are you sure you want to submit the post?"
        )
      }
      .navigationTitle("Create a Post")
      .onTapGesture {
        model.focusEditor()
      }
      .padding(.horizontal)
      .scrollDismissesKeyboard(.immediately)
      .sheet(isPresented: $model.isPreviewing) {
        NavigationStack {
          PreviewPostView(
            post: model.postText,
            showPreview: $model.isPreviewing
          )
        }
      }
      .toolbar {
        ToolbarItemGroup(placement: .topBarTrailing) {
          Button("Preview Post", systemImage: "doc", action: model.showPreview)
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

extension MainView {
  private class ViewModel: ObservableObject {
    @Published var editorFocused = false
    @Published var isPreviewing = false
    @Published var postText = "# howdy"
    @Published var shouldShowSubmitConfirmation = false

    private var accessToken: String?
    private var hasBeenPreviewed = false
    private var postTextSubscriptionCancellable: Cancellable?

    init() {
      postTextSubscriptionCancellable = $postText.sink { [weak self] _ in
        self?.hasBeenPreviewed = false
      }
    }

    deinit {
      postTextSubscriptionCancellable = nil
    }

    func focusEditor() {
      editorFocused = true
    }

    func setAccessToken(_ accessToken: String) {
      self.accessToken = accessToken
    }

    func showPreview() {
      hasBeenPreviewed = true
      isPreviewing = true
    }

    func submitPost() {
      submitPost(shouldOverridePreviewRequirement: false)
    }

    func submitPost(shouldOverridePreviewRequirement: Bool) {
      if shouldOverridePreviewRequirement || hasBeenPreviewed {
        print("do submit here!")
      } else {
        shouldShowSubmitConfirmation = true
      }
    }
  }
}

#Preview("Main Screen") {
  MainView()
    .environment(\.backendClient, PreviewBackendClient())
}
