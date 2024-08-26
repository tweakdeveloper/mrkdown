import SwiftUI

struct BlogSelectorView: View {
  var body: some View {
    Text("select a blog")
      .navigationTitle("Select a Blog")
  }
}

#Preview("Blog Selector Screen") {
  NavigationStack {
    BlogSelectorView()
  }
}
