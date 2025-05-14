import SwiftUI

struct GameView: View {
  // MARK: - Input
  var problems: [Int]
  var showHearts: Bool = true
  var onComplete: () -> Void     // ✅ Called when game ends successfully
  var onExit: () -> Void         // ✅ Called when paused and player exits

  // MARK: - State
  @State private var currentProblemIndex = 0
  @State private var userAnswer = ""
  @State private var playerHearts = 3
  @State private var isPaused = false

  // MARK: - Computed
  var currentNumber: Int? {
    guard currentProblemIndex < problems.count else { return nil }
    return problems[currentProblemIndex]
  }

  var enemyHealth: Int {
    problems.count - currentProblemIndex
  }

  var gameOver: Bool {
    playerHearts == 0 || currentProblemIndex >= problems.count
  }

  var body: some View {
    ZStack {
      Image("dungeonhallbackground")
        .interpolation(.none)
        .resizable()
        .scaledToFill()
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .clipped()
        .ignoresSafeArea()

      VStack(spacing: 20) {
        if showHearts {
          HStack(spacing: 5) {
            HeartsView(playerHearts: playerHearts)
            Spacer()
            Button(action: { isPaused = true }) {
              Image(systemName: "pause.circle.fill")
                .font(.system(size: 30))
                .foregroundColor(.gray)
                .padding()
            }
          }
          .frame(maxWidth: .infinity, alignment: .leading)
        }

        Spacer().padding(.top)

        HStack {
          ProgressView(value: Double(enemyHealth), total: Double(problems.count))
            .progressViewStyle(LinearProgressViewStyle(tint: .red))
            .frame(width: 240)
            .animation(.easeInOut, value: enemyHealth)
        }
        .font(.title2)
        .padding(.horizontal)

        if let number = currentNumber {
          Text("1 × \(number) = \(userAnswer)")
            .font(.largeTitle).colorInvert()
            .opacity(gameOver ? 0.5 : 1.0)
            .padding()
        }

        Spacer()

        if playerHearts == 0 {
          Text("Game Over!")
            .font(.largeTitle)
            .foregroundColor(.red)
        }

        if gameOver {
          Button("Continue") {
            onComplete() // ✅ Only for successful completion
          }
          .padding()
          .background(Color.green)
          .foregroundColor(.white)
          .clipShape(Capsule())
          .padding(.bottom)
        }

        if !gameOver {
          NumpadView(userAnswer: $userAnswer, onSubmit: checkAnswer)
        }
      }
      .padding()
      .frame(maxHeight: .infinity, alignment: .bottom)

      if isPaused {
        PauseMenuView(
          onResume: { isPaused = false },
          onExit: onExit // ✅ Cleanly exits to level select
        )
      }
    }
  }

  // MARK: - Logic

  private func checkAnswer() {
    guard !gameOver, let number = currentNumber else { return }

    if let answer = Int(userAnswer), answer == 1 * number {
      currentProblemIndex += 1

      if currentProblemIndex >= problems.count {
        // ✅ Level completed
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
          onComplete()
        }
      }
    } else {
      playerHearts = max(0, playerHearts - 1)
    }

    userAnswer = ""
  }
}
