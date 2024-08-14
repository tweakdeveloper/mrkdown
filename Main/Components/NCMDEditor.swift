import SwiftUI

struct NCMDEditor: UIViewRepresentable {
  @Binding var text: String

  func makeCoordinator() -> Coordinator {
    return Coordinator($text)
  }

  func makeUIView(context: Context) -> UITextView {
    let textView = UITextView()
    textView.delegate = context.coordinator
    textView.font = UIFont.preferredFont(forTextStyle: .body)
    textView.isScrollEnabled = false
    textView.text = text
    return textView
  }

  func updateUIView(_ uiView: UITextView, context: Context) {
    uiView.text = text
  }

  class Coordinator: NSObject, UITextViewDelegate {
    var text: Binding<String>

    init(_ text: Binding<String>) {
      self.text = text
    }

    func textViewDidChange(_ textView: UITextView) {
      self.text.wrappedValue = textView.text
    }
  }
}

/*
extension UITextView {
  func addToolbar(isRTL: Bool) {
    let toolbar = UIToolbar()
    let boldButton = UIBarButtonItem(image: UIImage(systemName: "bold"))
    let italicButton = UIBarButtonItem(image: UIImage(systemName: "italic"))
    let underlineButton = UIBarButtonItem(
      image: UIImage(systemName: "underline")
    )
    let fixedSpace = UIBarButtonItem(
      barButtonSystemItem: .fixedSpace,
      target: nil,
      action: nil
    )
    let flex = UIBarButtonItem(
      barButtonSystemItem: .flexibleSpace,
      target: nil,
      action: nil
    )
    let doneButton = UIBarButtonItem(
      barButtonSystemItem: .done,
      target: self,
      action: #selector(doneButtonTapped)
    )
    var items = [
      boldButton,
      fixedSpace,
      italicButton,
      fixedSpace,
      underlineButton,
      flex,
      doneButton
    ]
    if isRTL {
      items.reverse()
    }
    toolbar.items = items
    toolbar.sizeToFit()
    self.inputAccessoryView = toolbar
  }

  @objc func doneButtonTapped() {
    self.resignFirstResponder()
  }
}
*/

/*
 We're using a PreviewProvider here instead of a #Preview(_:traits:body:)
 because Apple still hasn't implemented that macro for iOS 16 and I'm not
 willing to bump iOS version (thereby losing iPhone 8 support) just for a
 slightly less verbose developer experience.
 */
struct NCMDEditor_Previews: PreviewProvider {
  static var previews: some View {
    NCMDEditor(text: Binding<String>.constant(.sample))
      .padding()
      .previewDevice("NC Markdown Editor")
      .previewLayout(.sizeThatFits)
  }
}
