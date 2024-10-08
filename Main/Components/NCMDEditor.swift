import SwiftUI

struct NCMDEditor: UIViewRepresentable {
  @Binding var focused: Bool
  @Binding var text: String

  init(text: Binding<String>, focused: Binding<Bool>) {
    self._focused = focused
    self._text = text
  }

  private func buildToolbar(withContext context: Context) -> UIToolbar {
    let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 1000, height: 50))
    let spacer = UIBarButtonItem(systemItem: .flexibleSpace)
    let done = UIBarButtonItem(
      title: "Done",
      style: .done,
      target: context.coordinator,
      action: #selector(Coordinator.doneButtonPressed)
    )
    toolbar.items = [spacer, done]
    toolbar.sizeToFit()
    return toolbar
  }

  func makeCoordinator() -> Coordinator {
    return Coordinator($text, $focused)
  }

  func makeUIView(context: Context) -> UITextView {
    let textView = UITextView()
    textView.delegate = context.coordinator
    textView.font = UIFont.preferredFont(forTextStyle: .body)
    textView.inputAccessoryView = buildToolbar(withContext: context)
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
      if !uiView.isFirstResponder && focused {
        uiView.becomeFirstResponder()
      } else if uiView.isFirstResponder && !focused {
        uiView.resignFirstResponder()
      }
    }
  }

  class Coordinator: NSObject, UITextViewDelegate {
    @Binding var focused: Bool
    @Binding var text: String

    init(_ text: Binding<String>, _ focused: Binding<Bool>) {
      self._text = text
      self._focused = focused
    }

    @objc func doneButtonPressed() {
      focused = false
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
      focused = true
    }

    func textViewDidChange(_ textView: UITextView) {
      text = textView.text
    }

    func textViewDidEndEditing(_ textView: UITextView) {
      focused = false
    }
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
      text: Binding<String>.constant(.sample),
      focused: Binding<Bool>.constant(false)
    )
    .padding()
    .previewDevice("NC Markdown Editor")
    .previewLayout(.sizeThatFits)
  }
}
