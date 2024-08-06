import SwiftUI

import Markdown

struct CreatePostView: View {
  @State private var isPreviewing: Bool = false
  @State private var postText: String = "# howdy y'all"
  
  var body: some View {
    NavigationStack {
      TextEditor(text: $postText)
        .navigationTitle("Create a Post")
        .sheet(isPresented: $isPreviewing) {
          NavigationStack {
            PreviewPostView(
              post: Document(parsing: postText),
              isPreviewing: $isPreviewing
            )
          }
        }
        .toolbar {
          ToolbarItem(placement: .topBarTrailing) {
            Button("Preview Post", systemImage: "eye") {
              isPreviewing = true
            }
          }
        }
    }
  }
}

#Preview {
  CreatePostView()
}
