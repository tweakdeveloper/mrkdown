import SwiftUI

import Markdown

struct PreviewPostView: View {
  @StateObject private var model: ViewModel

  private let post: String

  init(post: String, showPreview: Binding<Bool>) {
    self.post = post

    self._model = StateObject(wrappedValue: ViewModel(showPreview: showPreview))
  }

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

extension PreviewPostView {
  private class ViewModel: ObservableObject {
    @Binding var showPreview: Bool

    init(showPreview: Binding<Bool>) {
      self._showPreview = showPreview
    }

    func hidePreview() {
      showPreview = false
    }
  }
}

#Preview("Preview Post Screen") {
  NavigationStack {
    PreviewPostView(post: .sample, showPreview: Binding.constant(true))
  }
}
