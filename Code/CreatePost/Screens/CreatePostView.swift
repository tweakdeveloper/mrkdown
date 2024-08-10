import SwiftUI

struct CreatePostView: View {
  @State private var isPreviewing = false
  @State private var postText = "# howdy y'all"
  
  var body: some View {
    NavigationStack {
      TextEditor(text: $postText)
        .navigationTitle("Create a Post")
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
            Button("Preview Post", systemImage: "eye") {
              isPreviewing = true
            }
            Button("Submit Post", systemImage: "paperplane") {
              print("should submit post")
            }
          }
        }
    }
  }
}

#Preview {
  CreatePostView()
}
