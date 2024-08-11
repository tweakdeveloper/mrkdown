import SwiftUI

import Combine

class MainModel: ObservableObject {
  @Published var isPreviewing = false
  @Published var postText = "# howdy y'all"
  @Published var shouldShowSubmitConfirmation = false
  @Published var shouldLogUserIn = false

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
    } else {
      shouldShowSubmitConfirmation = true
    }
  }
}
