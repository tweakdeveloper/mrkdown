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
    postTextSubscriptionCancellable = $postText.sink { _ in
      self.hasBeenPreviewed = false
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
    if !hasBeenPreviewed {
      shouldShowSubmitConfirmation = true
    } else {
      print("should submit post")
    }
  }
}
