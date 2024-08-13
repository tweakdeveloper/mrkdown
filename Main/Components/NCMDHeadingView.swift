import SwiftUI

import Markdown

struct NCMDHeadingView: View {
  let heading: Heading

  var body: some View {
    let headingString = heading.format()
    let headingTextIndex = headingString.index(
      headingString.startIndex,
      offsetBy: heading.level + 1
    )
    let headingTextString = String(headingString[headingTextIndex...])
    let headingText = LocalizedStringKey(headingTextString)
    Text(headingText)
      .font(heading.level == 1 ? .title : .title2)
  }
}

/*
 We're using a PreviewProvider here instead of a #Preview(_:traits:body:)
 because Apple still hasn't implemented that macro for iOS 16 and I'm not
 willing to bump iOS version (thereby losing iPhone 8 support) just for a
 slightly less verbose developer experience.
 */
struct NCMDHeadingView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      NCMDHeadingView(heading: .level1)
        .previewDisplayName("Level 1 Heading")
      NCMDHeadingView(heading: .level2)
        .previewDisplayName("Level 2 Heading")
      NCMDHeadingView(heading: .complicated)
        .previewDisplayName("Complicated Heading")
    }
    .padding()
    .previewLayout(.sizeThatFits)
  }
}
