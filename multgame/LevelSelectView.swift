import SwiftUI

struct LevelSelectView: View {
  var onSelectLevel: (Int) -> Void
  var unlockedLevel: Int = 1
  
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
          let isUnlocked = level == 1 || level <= unlockedLevel
          let isPressed = pressedLevel == level
          
          let imageName = isUnlocked
          ? (isPressed ? "lv\(level)buttondown" : "lv\(level)buttonup")
          : "lv\(level)buttondisabled"
          
          Image(imageName)
            .interpolation(.none)
            .resizable()
            .frame(width: 280, height: 80)
            .contentShape(Rectangle())
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
