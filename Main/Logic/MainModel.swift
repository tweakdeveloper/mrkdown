import SwiftUI

import Combine

import Alamofire

class MainModel: ObservableObject {
  @Published var isPreviewing = false
  @Published var postText = "# howdy y'all"
  @Published var shouldShowSubmitConfirmation = false
  @Published var shouldLogUserIn = false

  private var authToken: String?
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

  func authCodeReceived(code: String) async {
    do {
      let response = try await AF.request(
        "https://mrkdown.slottedspoon.dev/exchange_code",
        method: .post,
        parameters: TokenExchangeParams(code: code),
        encoder: JSONParameterEncoder.default
      )
        .serializingDecodable(TokenExchangeResponse.self)
        .value
      authToken = response.accessToken
    } catch let error as AFError {
      print("networking error: \(error)")
    } catch {
      print("??? error: \(error)")
    }
  }

  func hidePreview() {
    isPreviewing = false
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
      }
    } else {
      shouldShowSubmitConfirmation = true
    }
  }
}
