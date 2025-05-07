import SwiftUI

struct Level1CoordinatorView: View {
  let onExit: () -> Void
  
  @State private var stageIndex = 0

  private let problems = [1, 2, 3]
  
  var body: some View {
    if stageIndex < stageSequence.count {
      stageSequence[stageIndex]
    } else {
      // Completion screen
      VStack(spacing: 20) {
        Text("🎉 Level 1 Complete!")
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
      AnyView(TeachingView(problem: 1, onComplete: advanceStage, onExit: onExit)
        .id("teaching-1")),
      AnyView(TeachingView(problem: 2, onComplete: advanceStage, onExit: onExit)
        .id("teaching-2")),
      AnyView(TeachingView(problem: 3, onComplete: advanceStage, onExit: onExit)
        .id("teaching-3")),
      AnyView(GameView(problems: problems.shuffled(), showHearts: true,
                       onComplete: advanceStage, onExit: onExit)
        .id("game-1-2-3"))

    ]
  }

  
  private func advanceStage() {
    stageIndex += 1
  }
}

#Preview {
  Level1CoordinatorView(onExit: {
    print("Level 1 finished (from preview).")
  })
}
