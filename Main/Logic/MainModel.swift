import SwiftUI

import Combine

import Alamofire

class MainModel: ObservableObject {
  private let apiBase = "https://mrkdown.slottedspoon.dev"

  @Published var isPreviewing = false
  @Published var postText = "# howdy y'all"
  @Published var shouldShowSubmitConfirmation = false
  @Published var shouldLogUserIn = false

  private var authToken: String?
  private var hasBeenPreviewed = false
  private var postTextSubscriptionCancellable: Cancellable?
  private var queue: [QueuedAction] = []

  private enum QueuedAction {
    case submitPost(String)
  }

  init() {
    postTextSubscriptionCancellable = $postText.sink { [weak self] _ in
      self?.hasBeenPreviewed = false
    }
  }

  deinit {
    postTextSubscriptionCancellable = nil
  }

  func authCodeReceived(code: String) async {
    do {
      let response = try await AF.request(
        "\(apiBase)/exchange_code",
        method: .post,
        parameters: TokenExchangeParams(code: code),
        encoder: JSONParameterEncoder.default
      )
        .serializingDecodable(TokenExchangeResponse.self)
        .value
      authToken = response.accessToken
      processQueue()
    } catch let error as AFError {
      print("networking error: \(error)")
    } catch {
      print("??? error: \(error)")
    }
  }

  func hidePreview() {
    isPreviewing = false
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
      print("should submit post")
      if authToken == nil {
        shouldLogUserIn = true
        queue.append(.submitPost(postText))
      } else {
        performPostSubmit(blog: "mrkdown-playground")
      }
    } else {
      shouldShowSubmitConfirmation = true
    }
  }
}
