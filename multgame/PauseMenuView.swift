import SwiftUI

struct PauseMenuView: View {
  var onResume: () -> Void
  var onExit: () -> Void
  
  var body: some View {
    ZStack {
      Color.black.opacity(0.5)
        .ignoresSafeArea()
      VStack(spacing: 20) {
        ImageButton(label: "resume", action: onResume)
        ImageButton(label: "back", action: onExit)
      }
      .frame(maxWidth: .infinity, alignment: .center)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}

struct ImageButton: View {
  let label: String
  let action: () -> Void
  
  @State private var isPressed = false
  
  var body: some View {
    Button(action: action) {
      Image(isPressed ? "\(label)buttondown" : "\(label)buttonup")
        .resizable()
        .interpolation(.none)
        .scaledToFit()
        .animation(nil, value: isPressed)
        .scaleEffect(isPressed ? 0.95 : 1.0)
    }
    .buttonStyle(NoEffectButtonStyle())
    .frame(height: 80)
    .simultaneousGesture(
      DragGesture(minimumDistance: 0)
        .onChanged { _ in withAnimation(nil) { isPressed = true } }
        .onEnded { _ in withAnimation(nil) { isPressed = false } }
    )
  }
}

struct NoEffectButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
  }
}
