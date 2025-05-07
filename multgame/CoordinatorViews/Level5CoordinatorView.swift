import SwiftUI

struct Level5CoordinatorView: View {
  let onExit: () -> Void

  @State private var bossDefeated = false
  private let problems = Array(1...12)

  var body: some View {
    if bossDefeated {
      VStack(spacing: 20) {
        Text("👑 Boss Defeated!")
          .font(.largeTitle)
          .padding()

        Button("Back to Levels") {
          onExit()
        }
        .padding()
        .background(Color.purple)
        .foregroundColor(.white)
        .clipShape(Capsule())
      }
    } else {
      GameView(
        problems: problems.shuffled(),   // ✅ shuffle for challenge
        showHearts: true,
        onComplete: {
          bossDefeated = true
        },
        onExit: onExit // ✅ pause menu exit
      )
      .id("boss-battle")
    }
  }
}
