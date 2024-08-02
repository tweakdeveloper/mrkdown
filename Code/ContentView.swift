import SwiftUI

struct ContentView: View {
  var body: some View {
    Button("sign in to tumblr", action: signIn)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
