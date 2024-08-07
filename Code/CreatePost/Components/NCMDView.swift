import SwiftUI

import Markdown

struct NCMDView: View, Identifiable {
  let id = UUID()

  let markdown: Markup

  var body: some View {
    switch(markdown) {
    case is Document:
      let markupChildren = markdown.children.map { markupChild in
        NCMDView(markdown: markupChild)
      }
      VStack {
        ForEach(markupChildren) { markupChild in
          markupChild
        }
      }
    case let heading as Heading:
      NCMDHeadingView(heading: heading)
    case let paragraph as Paragraph:
      NCMDParagraphView(paragraph: paragraph)
    default:
      Text("TODO: implement \(type(of: markdown))")
        .background(.red)
    }
  }
}

#Preview("NC Markdown View") {
  NCMDView(
    markdown: Document(
      parsing: """
# howdy y'all

what's goin' on?
"""
    )
  )
}
