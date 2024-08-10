import SwiftUI

struct MainView: View {
  @EnvironmentObject var model: MainModel

  @State private var shouldLogUserIn = false
  @State private var shouldShowSubmitConfirmation = false

  var body: some View {
    NavigationStack {
      TextEditor(text: $model.postText)
        .alert(
          Text("Submit post without previewing?"),
          isPresented: $model.shouldShowSubmitConfirmation
        ) {
          Button("No", role: .cancel, action: model.showPreview)
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
        .sheet(isPresented: $model.isPreviewing) {
          NavigationStack {
            PreviewPostView(post: model.postText)
          }
        }
        .sheet(isPresented: $model.shouldLogUserIn) {
          SignInView()
        }
        .toolbar {
          ToolbarItemGroup(placement: .topBarTrailing) {
            Button(
              "Preview Post",
              systemImage: "doc",
              action: model.showPreview
            )
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

#Preview {
  MainView()
    .environmentObject(MainModel())
}
