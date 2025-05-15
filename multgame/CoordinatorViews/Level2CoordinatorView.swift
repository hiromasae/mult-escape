import SwiftUI

struct Level2CoordinatorView: View {
  let onComplete: () -> Void
  let onExit: () -> Void

  @State private var stageIndex = 0
  private let problems = [4, 5, 6]

  var body: some View {
    if stageIndex < stageSequence.count {
      stageSequence[stageIndex]
    }
  }

  private var stageSequence: [AnyView] {
    [
      AnyView(TeachingView(problem: 4, onComplete: advanceStage, onExit: onExit, level: 2)
        .id("teach-4")),
      AnyView(TeachingView(problem: 5, onComplete: advanceStage, onExit: onExit, level: 2)
        .id("teach-5")),
      AnyView(TeachingView(problem: 6, onComplete: advanceStage, onExit: onExit, level: 2)
        .id("teach-6")),
      AnyView(GameView(problems: problems.shuffled(), showHearts: true,
                       onComplete: advanceStage, onExit: onExit, level: 2)
        .id("game-4-5-6"))
    ]
  }

  private func advanceStage() {
    stageIndex += 1
    if stageIndex == stageSequence.count {
      onComplete()
    }
  }

}

