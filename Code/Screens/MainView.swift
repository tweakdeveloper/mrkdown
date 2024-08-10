import SwiftUI

struct MainView: View {
  @State private var hasBeenPreviewed = false
  @State private var isPreviewing = false
  @State private var postText = "# howdy y'all"
  @State private var shouldShowSubmitConfirmation = false

  private func showPreview() {
    isPreviewing = true
    hasBeenPreviewed = true
  }

  var body: some View {
    NavigationStack {
      TextEditor(text: $postText)
        .alert(
          Text("Submit post without previewing?"),
          isPresented: $shouldShowSubmitConfirmation
        ) {
          Button("No", role: .cancel) {
            showPreview()
          }
          Button("Yes", role: .destructive) {
            print("should submit post anyway")
          }
        } message: {
          Text(
            "You haven't yet previewed your latest modifications to the " +
            "post. Are you sure you want to submit the post?"
          )
        }
        .navigationTitle("Create a Post")
        .onChange(of: postText) { _ in
          hasBeenPreviewed = false
        }
        .sheet(isPresented: $isPreviewing) {
          NavigationStack {
            PreviewPostView(
              post: postText,
              isPreviewing: $isPreviewing
            )
          }
        }
        .toolbar {
          ToolbarItemGroup(placement: .topBarTrailing) {
            Button("Preview Post", systemImage: "doc") {
              showPreview()
            }
            Button("Submit Post", systemImage: "paperplane") {
              if !hasBeenPreviewed {
                shouldShowSubmitConfirmation = true
              } else {
                print("should submit post")
              }
            }
          }
        }
    }
  }
}

#Preview {
  MainView()
}
