import SwiftUI

struct Level1CoordinatorView: View {
  let onComplete: () -> Void
  let onExit: () -> Void
  
  @State private var stageIndex = 0

  private let problems = [1, 2, 3]
  
  var body: some View {
    if stageIndex < stageSequence.count {
      stageSequence[stageIndex]
    }
  }
  
  private var stageSequence: [AnyView] {
    [
      AnyView(TeachingView(problem: 1, onComplete: advanceStage, onExit: onExit, level: 1)
        .id("teaching-1")),
      AnyView(TeachingView(problem: 2, onComplete: advanceStage, onExit: onExit, level: 1)
        .id("teaching-2")),
      AnyView(TeachingView(problem: 3, onComplete: advanceStage, onExit: onExit, level: 1)
        .id("teaching-3")),
      AnyView(GameView(problems: problems.shuffled(), showHearts: true,
                       onComplete: advanceStage, onExit: onExit, level: 1)
        .id("game-1-2-3"))

    ]
  }

  private func advanceStage() {
    stageIndex += 1
    if stageIndex == stageSequence.count {
      onComplete()
    }
  }
}
