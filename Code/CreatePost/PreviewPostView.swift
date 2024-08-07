import SwiftUI

import Markdown

struct PreviewPostView: View {
  let post: Document
  
  @Binding var isPreviewing: Bool
  
  var body: some View {
    NCMDView(markdown: post)
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
      post: Document(
        parsing: """
# howdy y'all

what's goin' on?
"""
      ),
      isPreviewing: Binding.constant(true)
    )
  }
}
