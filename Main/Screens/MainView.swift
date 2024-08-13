import SwiftUI

struct MainView: View {
  @EnvironmentObject var model: MainModel

  @FocusState private var editorIsFocused

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
        .focused($editorIsFocused)
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
          ToolbarItemGroup(placement: .keyboard) {
            Spacer()
            Button("Done") {
              editorIsFocused = false
            }
          }
          ToolbarItemGroup(placement: .topBarTrailing) {
            Menu("More Options", systemImage: "ellipsis.rectangle") {
              NavigationLink {
                AboutView()
              } label: {
                Label("About mrkdown", systemImage: "info")
              }
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

#Preview("Main Screen") {
  MainView()
    .environmentObject(MainModel())
}
