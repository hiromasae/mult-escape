import SwiftUI

struct Level4CoordinatorView: View {
  let onExit: () -> Void

  @State private var stageIndex = 0
  private let problems = [10, 11, 12]

  var body: some View {
    if stageIndex < stageSequence.count {
      stageSequence[stageIndex]
    } else {
      VStack(spacing: 20) {
        Text("🎉 Level 4 Complete!")
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
      AnyView(TeachingView(problem: 10, onComplete: advanceStage, onExit: onExit)
        .id("teach-10")),
      AnyView(TeachingView(problem: 11, onComplete: advanceStage, onExit: onExit)
        .id("teach-11")),
      AnyView(TeachingView(problem: 12, onComplete: advanceStage, onExit: onExit)
        .id("teach-12")),
      AnyView(GameView(problems: problems.shuffled(), showHearts: true,
                       onComplete: advanceStage, onExit: onExit)
        .id("game-10-11-12"))
    ]
  }

  private func advanceStage() {
    stageIndex += 1
  }
}
