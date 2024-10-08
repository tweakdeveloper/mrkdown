import Markdown

extension Heading {
  static let level1 = Heading(level: 1, [Text("howdy")])
  static let level2 = Heading(level: 2, [Text("howdy")])
  static let complicated = Heading(
    level: 1,
    Text("howdy "),
    Emphasis(Text("all")),
    Text(" y'all")
  )
}

extension Paragraph {
  static let sample = Paragraph(Text("hi there"))
  static let leadingNewline = Paragraph(Text("\n\nhowdy y'all"))
}

extension String {
  static let sample = """
# howdy y'all

what's goin' on?
"""
}
