import SwiftUI

struct NumpadView: View {
  @Binding var userAnswer: String
  var onSubmit: () -> Void

  var body: some View {
    ZStack {
      Image("numpadbackground")
        .interpolation(.none)
        .resizable()
        .scaledToFill()
        .frame(width: 320, height: 280)
      
      VStack(spacing: 10) {
        // Rows 1–9
        ForEach([[1, 2, 3], [4, 5, 6], [7, 8, 9]], id: \.self) { row in
          HStack(spacing: 10) {
            ForEach(row, id: \.self) { number in
              ImageButton(label: "\(number)") {
                userAnswer.append(String(number))
              }
            }
          }
        }
        
        // Bottom row: Clear, 0, Submit
        HStack(spacing: 10) {
          ImageButton(label: "clear") {
            userAnswer = ""
          }
          
          ImageButton(label: "0") {
            userAnswer.append("0")
          }
          
          ImageButton(label: "enter") {
            onSubmit()
          }
        }
      }
    }
    .padding(.bottom)
  }

  struct ImageButton: View {
    let label: String  // e.g., "1", "2", "clear", "enter"
    let action: () -> Void

    @State private var isPressed = false

    var body: some View {
      Button(action: action) {
        Image(isPressed ? "\(label)buttondown" : "\(label)buttonup")
          .resizable()
          .interpolation(.none)
          .scaledToFit()
          .animation(nil, value: isPressed) // disables fade
          .scaleEffect(isPressed ? 0.95 : 1.0) // optional feedback
      }
      .buttonStyle(NoEffectButtonStyle())
      .frame(width: 60, height: 60)
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

}

struct StatefulPreviewWrapper<Value, Content: View>: View {
  @State private var value: Value
  private let content: (Binding<Value>) -> Content

  init(_ initialValue: Value, @ViewBuilder content: @escaping (Binding<Value>) -> Content) {
    self._value = State(initialValue: initialValue)
    self.content = content
  }

  var body: some View {
    content($value)
  }
}

#Preview {
  StatefulPreviewWrapper("") { binding in
    NumpadView(
      userAnswer: binding,
      onSubmit: { print("Submit tapped") }
    )
    .padding()
    .background(Color.black)
  }
}
