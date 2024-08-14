import SwiftUI

struct NCMDEditor: UIViewRepresentable {
  @Binding var focused: Bool
  @Binding var text: String

  func makeCoordinator() -> Coordinator {
    return Coordinator($text, $focused)
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
    // Content
    uiView.text = text
    // Focus
    DispatchQueue.main.asyncAfter(
      deadline: DispatchTime.now() + .milliseconds(100)
    ) {
      if !uiView.isFocused && focused {
        uiView.becomeFirstResponder()
      } else if uiView.isFocused && !focused {
        uiView.resignFirstResponder()
      }
    }
  }

  class Coordinator: NSObject, UITextViewDelegate {
    var focused: Binding<Bool>
    var text: Binding<String>

    init(_ text: Binding<String>, _ focused: Binding<Bool>) {
      self.text = text
      self.focused = focused
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
      focused.wrappedValue = true
    }

    func textViewDidChange(_ textView: UITextView) {
      text.wrappedValue = textView.text
    }

    func textViewDidEndEditing(_ textView: UITextView) {
      focused.wrappedValue = false
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
    NCMDEditor(
      focused: Binding<Bool>.constant(false),
      text: Binding<String>.constant(.sample)
    )
      .padding()
      .previewDevice("NC Markdown Editor")
      .previewLayout(.sizeThatFits)
  }
}
