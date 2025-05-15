import SwiftUI

struct Level4CoordinatorView: View {
  let onComplete: () -> Void
  let onExit: () -> Void
  
  @State private var stageIndex = 0
  private let problems = [10, 11, 12]
  
  var body: some View {
    if stageIndex < stageSequence.count {
      stageSequence[stageIndex]
    }
  }
  
  private var stageSequence: [AnyView] {
    [
      AnyView(TeachingView(problem: 10, onComplete: advanceStage, onExit: onExit, level: 4)
        .id("teach-10")),
      AnyView(TeachingView(problem: 11, onComplete: advanceStage, onExit: onExit, level: 4)
        .id("teach-11")),
      AnyView(TeachingView(problem: 12, onComplete: advanceStage, onExit: onExit, level: 4)
        .id("teach-12")),
      AnyView(GameView(problems: problems.shuffled(), showHearts: true,
                       onComplete: advanceStage, onExit: onExit, level: 4)
        .id("game-10-11-12"))
    ]
  }
  
  private func advanceStage() {
    stageIndex += 1
    if stageIndex == stageSequence.count {
      onComplete()
    }
  }
}
