import SwiftUI

struct TeachingView: View {
  struct CircleItem: Identifiable {
    let id = UUID()
    var xOffset: CGFloat
    var yOffset: CGFloat
    var isTapped: Bool = false
  }

  // MARK: - Input
  let problem: Int
  let onComplete: () -> Void     // Called when problem is solved
  let onExit: () -> Void         // Called when exiting via pause menu

  // MARK: - State
  @State private var circleItems: [CircleItem] = []
  @State private var taps = 0
  @State private var userAnswer = ""
  @State private var stageComplete = false
  @State private var showInput = false
  @State private var showFinalAnswerBriefly = false
  @State private var randomOffsets: [UUID: CGSize] = [:]
  @State private var isPaused = false

  // MARK: - Computed
  private var displayAnswer: String {
    if stageComplete && !showInput {
      return "\(taps)"
    } else if showInput {
      return userAnswer.isEmpty ? "" : userAnswer
    } else {
      return taps == 0 ? "" : "\(taps)"
    }
  }

  // MARK: - Body
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
        HStack {
          Text("Learn")
            .font(.largeTitle)
            .padding()

          Spacer()

          Button(action: {
            isPaused = true
          }) {
            Image(systemName: "pause.circle.fill")
              .font(.system(size: 30))
              .foregroundColor(.gray)
              .padding()
          }
        }
        .padding(.horizontal)
        Spacer()
        Spacer()
        Spacer()
        
        HStack {
          Text("1 × \(problem) = ")
          Text(displayAnswer)
        }
        .font(.title).colorInvert()
        .padding()

        Spacer()

        ZStack {
          ForEach(circleItems) { item in
            Button(action: {
              handleTap(item: item)
            }) {
              ZStack {
                SlimeView(
                  frameNames: item.isTapped
                    ? ["slime_tapped"]
                    : ["greenslime1", "greenslime2", "greenslime3",
                       "greenslime2"],
                  frameDuration: 0.2,
                  size: 150
                )

                VStack {
                  Spacer()
                  Text("1")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(.bottom, 4)
                }
              }
              .frame(width: 150, height: 150)
            }
            .offset(
              x: item.xOffset + (randomOffsets[item.id]?.width ?? 0),
              y: item.yOffset + (randomOffsets[item.id]?.height ?? 0)
            )
            .disabled(item.isTapped || stageComplete)
          }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)

        Spacer()

        if showInput {
          VStack(spacing: 10) {
            NumpadView(userAnswer: $userAnswer, onSubmit: checkAnswer)
          }
          .padding()
        }
      }

      // ✅ Pause Menu Overlay
      if isPaused {
        PauseMenuView(
          onResume: { isPaused = false },
          onExit: { onExit() } // ✅ no longer triggers onComplete!
        )
      }
    }
    .onAppear {
      resetStage()
      startRandomMovement()
    }
    .onChange(of: problem) {
      resetStage()
    }
  }

  // MARK: - Logic

  private func generateCircles() {
    circleItems = []
    randomOffsets = [:]
    for _ in 0..<problem {
      let randomX = CGFloat.random(in: -120...120)
      let randomY = CGFloat.random(in: -200...200)
      let newItem = CircleItem(xOffset: randomX, yOffset: randomY)
      circleItems.append(newItem)
      randomOffsets[newItem.id] = .zero
    }
  }

  private func handleTap(item: CircleItem) {
    guard !stageComplete else { return }

    if let index = circleItems.firstIndex(where: { $0.id == item.id }) {
      circleItems.remove(at: index)
      taps += 1

      if taps == problem {
        stageComplete = true
        showFinalAnswerBriefly = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
          showFinalAnswerBriefly = false
          showInput = true
        }
      }
    }
  }

  private func checkAnswer() {
    if let answer = Int(userAnswer), answer == 1 * problem {
      onComplete() // ✅ only triggered after correct answer
    } else {
      retryTapping()
    }
  }

  private func resetStage() {
    taps = 0
    userAnswer = ""
    stageComplete = false
    showInput = false
    showFinalAnswerBriefly = false
    generateCircles()
  }

  private func startRandomMovement() {
    withAnimation(Animation.interpolatingSpring(stiffness: 40, damping: 6).speed(0.25)) {
      for id in randomOffsets.keys {
        randomOffsets[id] = randomSlimeOffset()
      }
    }

    Timer.scheduledTimer(withTimeInterval: 3.5, repeats: true) { _ in
      withAnimation(Animation.interpolatingSpring(stiffness: 40, damping: 6).speed(0.25)) {
        for id in randomOffsets.keys {
          randomOffsets[id] = randomSlimeOffset()
        }
      }
    }
  }

  private func randomSlimeOffset() -> CGSize {
    CGSize(
      width: CGFloat.random(in: -18...18),
      height: CGFloat.random(in: -12...12)
    )
  }

  private func retryTapping() {
    resetStage()
  }
}

#Preview {
  TeachingView(
    problem: 3, // ⬅️ test with 1×3
    onComplete: {
      print("Preview completed")
    },
    onExit: {
      print("Preview exited")
    }
  )
}
