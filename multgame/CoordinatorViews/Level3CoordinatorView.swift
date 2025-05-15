import SwiftUI

struct Level3CoordinatorView: View {
  let onComplete: () -> Void
  let onExit: () -> Void
  
  @State private var stageIndex = 0
  private let problems = [7, 8, 9]
  
  var body: some View {
    if stageIndex < stageSequence.count {
      stageSequence[stageIndex]
    }
  }
  
  private var stageSequence: [AnyView] {
    [
      AnyView(TeachingView(problem: 7, onComplete: advanceStage, onExit: onExit, level: 3)
        .id("teach-7")),
      AnyView(TeachingView(problem: 8, onComplete: advanceStage, onExit: onExit, level: 3)
        .id("teach-8")),
      AnyView(TeachingView(problem: 9, onComplete: advanceStage, onExit: onExit, level: 3)
        .id("teach-9")),
      AnyView(GameView(problems: problems.shuffled(), showHearts: true,
                       onComplete: advanceStage, onExit: onExit, level: 3)
        .id("game-7-8-9"))
    ]
  }
  
  private func advanceStage() {
    stageIndex += 1
    if stageIndex == stageSequence.count {
      onComplete()
    }
  }
}
