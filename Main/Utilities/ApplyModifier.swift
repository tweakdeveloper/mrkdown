import SwiftUI

extension View {
  func apply<Content: View>(
    @ViewBuilder _ codeToRun: (Self) -> Content
  ) -> some View {
    return codeToRun(self)
  }
}
