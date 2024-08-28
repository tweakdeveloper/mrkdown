import SwiftUI

import Combine

struct MainView: View {
  @StateObject private var model = ViewModel()

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
}
