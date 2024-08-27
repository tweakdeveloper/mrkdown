import SwiftUI

import Combine

import Alamofire

class MainModel: ObservableObject {
  private let apiBase = "https://mrkdown.slottedspoon.dev"

  @Environment(\.webAuthenticationSession) private var webAuthenticationSession

  @Published var isPreviewing = false
  @Published var postText = "# howdy y'all"
  @Published var shouldShowSubmitConfirmation = false

  private var authToken: String?
  private var hasBeenPreviewed = false
  private var postTextSubscriptionCancellable: Cancellable?
  private var queue: [QueuedAction] = []

  private enum QueuedAction {
    case submitPost(String)
  }

  private enum SignInError: Error {
    case codeNotReceived
    case stateDidNotMatch(String)
    case stateNotReceived
  }

  init() {
    postTextSubscriptionCancellable = $postText.sink { [weak self] _ in
      self?.hasBeenPreviewed = false
    }
  }

  deinit {
    postTextSubscriptionCancellable = nil
  }

  private func authCodeReceived(code: String) {
    Task.detached(priority: .userInitiated) {
      do {
        let response = try await AF.request(
          "\(self.apiBase)/exchange_code",
          method: .post,
          parameters: TokenExchangeParams(code: code),
          encoder: JSONParameterEncoder.default
        )
          .serializingDecodable(TokenExchangeResponse.self)
          .value
        self.authToken = response.accessToken
        self.processQueue()
      } catch let error as AFError {
        print("networking error: \(error)")
      } catch {
        print("??? error: \(error)")
      }
    }
  }

  private func buildAuthURL(withState state: String) -> URL {
    var baseURL = URL(string: "\(apiBase)/init_auth_flow")!
    baseURL.append(queryItems: [
      URLQueryItem(name: "state", value: state),
      URLQueryItem(name: "mobile", value: "true")
    ])
    return baseURL
  }

  func hidePreview() {
    isPreviewing = false
  }

  private func performLogin() async {
    let state = UUID().uuidString
    let authURL = buildAuthURL(withState: state)
    do {
      let urlWithToken = try await webAuthenticationSession.authenticate(
        using: authURL,
        callbackURLScheme: "mrkdown",
        preferredBrowserSession: .shared
      )
      guard let receivedState = urlWithToken.getQueryItem("state") else {
        throw SignInError.stateNotReceived
      }
      if receivedState == state {
        guard let code = urlWithToken.getQueryItem("code") else {
          throw SignInError.codeNotReceived
        }
        authCodeReceived(code: code)
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

  private func performPostSubmit(postText: String? = nil, blog: String) {
    Task.detached(priority: .userInitiated) {
      guard let authToken = self.authToken else {
        return
      }
      let headers: HTTPHeaders = [
        .authorization(bearerToken: authToken),
        .contentType("text/markdown")
      ]
      do {
        var apiRequest = try URLRequest(
          url: "\(self.apiBase)/create_post/\(blog)",
          method: .post,
          headers: headers
        )
        if let postText = postText {
          apiRequest.httpBody = postText.data(using: .utf8)
        } else {
          apiRequest.httpBody = self.postText.data(using: .utf8)
        }
        let apiResponse = try await AF.request(apiRequest)
          .serializingDecodable(CreatePostResponse.self)
          .value
        print("created post: \(apiResponse.response["id"]!)")
      } catch let error as AFError {
        print("networking error: \(error)")
      } catch {
        print("??? error: \(error)")
      }
    }
  }

  private func processQueue() {
    var itemsExistInQueue = queue.count != 0
    while itemsExistInQueue {
      let action = queue.removeFirst()
      switch action {
      case .submitPost(let postText):
        // TODO: add ability to specify blog
        performPostSubmit(postText: postText, blog: "mrkdown-playground")
      }
      itemsExistInQueue = queue.count != 0
    }
  }

  func showPreview() {
    hasBeenPreviewed = true
    isPreviewing = true
  }

  func submitPost() {
    submitPost(shouldOverrideConfirmation: false)
  }

  func submitPost(shouldOverrideConfirmation: Bool) {
    if shouldOverrideConfirmation || hasBeenPreviewed {
      if authToken == nil {
        Task(priority: .userInitiated) {
          await performLogin()
        }
        queue.append(.submitPost(postText))
      } else {
        performPostSubmit(blog: "mrkdown-playground")
      }
    } else {
      shouldShowSubmitConfirmation = true
    }
  }
}
