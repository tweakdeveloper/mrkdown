import SwiftUI

struct CreatePostView: View {
  @State private var post: String = "# howdy y'all"
  
  var body: some View {
    TextEditor(text: $post)
  }
}

#Preview {
  CreatePostView()
}
