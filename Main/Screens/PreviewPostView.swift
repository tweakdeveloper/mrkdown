import SwiftUI

import Markdown

struct PreviewPostView: View {
  @EnvironmentObject var model: MainModel

  let post: String

  var body: some View {
    ScrollView {
      NCMDView(markdown: Document(parsing: post))
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Post Preview")
        .toolbar {
          ToolbarItem(placement: .topBarTrailing) {
            Button("Done", action: model.hidePreview)
          }
        }
    }
    .padding(.horizontal)
  }
}

#Preview("Preview Post Screen") {
  NavigationStack {
    PreviewPostView(post: .sample)
    .environmentObject(MainModel())
  }
}
