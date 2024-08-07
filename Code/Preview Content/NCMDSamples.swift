import Markdown

let level1 = Heading(level: 1, [Text("howdy")])
let level2 = Heading(level: 2, [Text("howdy")])
let complicated = Heading(
  level: 1,
  Text("howdy "),
  Emphasis(Text("all")),
  Text(" y'all")
)

let sample = Paragraph(Text("hi there"))
