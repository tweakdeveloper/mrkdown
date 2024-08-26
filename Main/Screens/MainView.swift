import SwiftUI

import AuthenticationServices

struct MainView: View {
  @StateObject private var model = MainModel()

  @State private var editorFocused = false

  var body: some View {
    NavigationStack {
      ScrollView {
        NCMDEditor(text: $model.postText, focused: $editorFocused)
      }
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
      .onTapGesture {
        editorFocused = true
      }
      .padding(.horizontal)
      .sheet(isPresented: $model.isPreviewing) {
        NavigationStack {
          PreviewPostView(post: model.postText)
        }
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
            NavigationLink {
              BlogSelectorView()
            } label: {
              Label("Blog", systemImage: "person.crop.circle.badge.checkmark")
            }
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
}
