import SwiftUI

struct NCMDEditor: UIViewRepresentable {
  @Environment(\.layoutDirection) private var direction

  @Binding var shouldShowKeyboard: Bool
  @Binding var text: String

  func makeCoordinator() -> Coordinator {
    return Coordinator($text, $shouldShowKeyboard)
  }

  func makeUIView(context: Context) -> UITextView {
    let textView = UITextView()
    textView.addToolbar(isRTL: direction == .rightToLeft)
    textView.delegate = context.coordinator
    textView.font = UIFont.preferredFont(forTextStyle: .body)
    textView.isScrollEnabled = false
    textView.text = text
    return textView
  }

  func updateUIView(_ uiView: UITextView, context: Context) {
    uiView.addToolbar(isRTL: direction == .rightToLeft)
    uiView.text = text
    if shouldShowKeyboard {
      uiView.becomeFirstResponder()
    } else {
      uiView.resignFirstResponder()
    }
  }

  class Coordinator: NSObject, UITextViewDelegate {
    var shouldShowKeyboard: Binding<Bool>
    var text: Binding<String>

    init(_ text: Binding<String>, _ shouldShowKeyboard: Binding<Bool>) {
      self.text = text
      self.shouldShowKeyboard = shouldShowKeyboard
    }

    func textViewDidChange(_ textView: UITextView) {
      self.text.wrappedValue = textView.text
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
      self.shouldShowKeyboard.wrappedValue = true
    }

    func textViewDidEndEditing(_ textView: UITextView) {
      self.shouldShowKeyboard.wrappedValue = false
    }
  }
}

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

/*
 We're using a PreviewProvider here instead of a #Preview(_:traits:body:)
 because Apple still hasn't implemented that macro for iOS 16 and I'm not
 willing to bump iOS version (thereby losing iPhone 8 support) just for a
 slightly less verbose developer experience.
 */
struct NCMDEditor_Previews: PreviewProvider {
  static var previews: some View {
    NCMDEditor(
      shouldShowKeyboard: Binding.constant(false),
      text: Binding<String>.constant(.sample)
    )
      .padding()
      .previewDevice("NC Markdown Editor")
      .previewLayout(.sizeThatFits)
  }
}
