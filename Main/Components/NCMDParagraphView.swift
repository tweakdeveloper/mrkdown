import SwiftUI

import Markdown

struct NCMDParagraphView: View {
  let paragraph: Paragraph

  var body: some View {
    Text(
      LocalizedStringKey(
        String(paragraph.format().trimmingPrefix(/\s+/))
      )
    )
  }
}

/*
 We're using a PreviewProvider here instead of a #Preview(_:traits:body:)
 because Apple still hasn't implemented that macro for iOS 16 and I'm not
 willing to bump iOS version (thereby losing iPhone 8 support) just for a
 slightly less verbose developer experience.
 */
struct NCMDParagraphView_Previews: PreviewProvider {
  static var previews: some View {
    NCMDParagraphView(paragraph: .sample)
      .padding()
      .previewDisplayName("Simple Paragraph")
      .previewLayout(.sizeThatFits)
    NCMDParagraphView(paragraph: .leadingNewline)
      .padding()
      .previewDisplayName("Leading Newline Paragraph")
      .previewLayout(.sizeThatFits)
  }
}
