import SwiftUI

import Markdown

struct PreviewPostView: View {
  let post: String

  @Binding var isPreviewing: Bool

  var body: some View {
    NCMDView(markdown: Document(parsing: post))
      .navigationBarTitleDisplayMode(.inline)
      .navigationTitle("Post Preview")
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button("Done") {
            isPreviewing = false
          }
        }
      }
  }
}

#Preview {
  NavigationStack {
    PreviewPostView(
      post: """
# howdy y'all

what's goin' on?
""",
      isPreviewing: Binding.constant(true)
    )
  }
}
