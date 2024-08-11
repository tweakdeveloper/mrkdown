import SwiftUI

struct MainView: View {
  @EnvironmentObject var model: MainModel

  var body: some View {
    NavigationStack {
      TextEditor(text: $model.postText)
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

#Preview {
  MainView()
    .environmentObject(MainModel())
}
