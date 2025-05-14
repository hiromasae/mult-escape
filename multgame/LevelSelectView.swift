import SwiftUI

struct LevelSelectView: View {
  var onSelectLevel: (Int) -> Void
  var unlockedLevel: Int = 5  // Optional: still here for future use

  @State private var pressedLevel: Int? = nil

  var body: some View {
    ZStack {
      Image("stonewall")
        .interpolation(.none)
        .resizable()
        .scaledToFill()
        .ignoresSafeArea()

      VStack(spacing: 32) {
        Spacer()
  
        ForEach(1...5, id: \.self) { level in
          let isUnlocked = true  // For testing
          let isPressed = pressedLevel == level
          let imageName = isPressed ? "lv\(level)buttondown" : "lv\(level)buttonup"
          
          Image(imageName)
            .interpolation(.none)
            .resizable()
            .frame(width: 280, height: 80)
            .opacity(isUnlocked ? 1.0 : 0.5)
            .contentShape(Rectangle()) // Ensures entire image is tappable
            .gesture(
              DragGesture(minimumDistance: 0)
                .onChanged { _ in
                  if isUnlocked { pressedLevel = level }
                }
                .onEnded { _ in
                  if isUnlocked {
                    pressedLevel = nil
                    onSelectLevel(level)
                  }
                }
            )
        }

        Spacer()
      }
      .padding()
    }
  }
}

#Preview {
  LevelSelectView(onSelectLevel: { level in
    print("Selected level \(level)")
  })
}
