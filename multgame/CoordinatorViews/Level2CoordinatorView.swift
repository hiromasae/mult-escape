import SwiftUI

struct Level2CoordinatorView: View {
  let onExit: () -> Void

  @State private var stageIndex = 0
  private let problems = [4, 5, 6]

  var body: some View {
    if stageIndex < stageSequence.count {
      stageSequence[stageIndex]
    } else {
      VStack(spacing: 20) {
        Text("🎉 Level 2 Complete!")
          .font(.largeTitle)
          .padding()

        Button("Back to Levels") {
          onExit()
        }
        .padding()
        .background(Color.blue)
        .foregroundColor(.white)
        .clipShape(Capsule())
      }
    }
  }

  private var stageSequence: [AnyView] {
    [
      AnyView(TeachingView(problem: 4, onComplete: advanceStage, onExit: onExit)
        .id("teach-4")),
      AnyView(TeachingView(problem: 5, onComplete: advanceStage, onExit: onExit)
        .id("teach-5")),
      AnyView(TeachingView(problem: 6, onComplete: advanceStage, onExit: onExit)
        .id("teach-6")),
      AnyView(GameView(problems: problems.shuffled(), showHearts: true,
                       onComplete: advanceStage, onExit: onExit)
        .id("game-4-5-6"))
    ]
  }

  private func advanceStage() {
    stageIndex += 1
  }
}

