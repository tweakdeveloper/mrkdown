import SwiftUI

import Markdown

struct PreviewPostView: View {
  @EnvironmentObject var model: MainModel

  let post: String

  var body: some View {
    NCMDView(markdown: Document(parsing: post))
      .navigationBarTitleDisplayMode(.inline)
      .navigationTitle("Post Preview")
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button("Done", action: model.hidePreview)
        }
      }
  }
}

#Preview("Preview Post Screen") {
  NavigationStack {
    PreviewPostView(
      post: """
# howdy y'all

what's goin' on?
"""
    )
    .environmentObject(MainModel())
  }
}
