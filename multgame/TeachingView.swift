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
  let level: Int
  
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
    }
    else if showInput {
      return userAnswer.isEmpty ? "" : userAnswer
    }
    else {
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
          Spacer()
          PauseButton {
            isPaused = true
          }
          .padding()
        }
        .padding(.horizontal)
        Spacer()
        Spacer()
        Spacer()
        
        HStack {
          Text("1 × \(problem) = ")
          Text(displayAnswer)
        }
        .font(.largeTitle).colorInvert().bold()
        .padding()
        
        Spacer()
        
        ZStack {
          ForEach(circleItems) { item in
            Button(action: {
              handleTap(item: item)
            }) {
              ZStack {
                SlimeView(
                  frameNames: slimeFrames(forTapped: item.isTapped),
                  frameDuration: 0.15,
                  size: 150,
                  isPaused: isPaused
                )
                VStack {
                  Spacer()
                  Text("1")
                    .font(.title)
                    .foregroundColor(textColorForSlime)
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
      
      if isPaused {
        PauseMenuView(
          onResume: { isPaused = false },
          onExit: { onExit() }
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
      onComplete()
    }
    else {
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
      if !isPaused {
        withAnimation(Animation.interpolatingSpring(stiffness: 40, damping: 6).speed(0.25)) {
          for id in randomOffsets.keys {
            randomOffsets[id] = randomSlimeOffset()
          }
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
  
  private func slimeFrames(forTapped tapped: Bool) -> [String] {
    if tapped {
      return ["slime_tapped"]
    }
    
    switch level {
    case 1: return ["greenslime1", "greenslime2", "greenslime3", "greenslime2"]
    case 2: return ["blueslime1", "blueslime2", "blueslime3", "blueslime2"]
    case 3: return ["yellowslime1", "yellowslime2", "yellowslime3", "yellowslime2"]
    case 4: return ["redslime1", "redslime2", "redslime3", "redslime2"]
    default: return ["greenslime1", "greenslime2", "greenslime3", "greenslime2"]
    }
  }
  
  private var textColorForSlime: Color {
    switch level {
    case 3:
      return .black // yellow slime needs black text
    default:
      return .white
    }
  }
  
  struct PauseButton: View {
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
      Button(action: action) {
        Image(isPressed ? "pausebuttondown" : "pausebuttonup")
          .resizable()
          .interpolation(.none)
          .scaledToFit()
          .frame(width: 50, height: 50)
          .animation(nil, value: isPressed)
          .scaleEffect(isPressed ? 0.95 : 1.0)
      }
      .buttonStyle(PlainButtonStyle())
      .simultaneousGesture(
        DragGesture(minimumDistance: 0)
          .onChanged { _ in withAnimation(nil) { isPressed = true } }
          .onEnded { _ in withAnimation(nil) { isPressed = false } }
      )
    }
  }
}

#Preview {
  TeachingView(
    problem: 1,
    onComplete: { print("Preview completed") },
    onExit: { print("Preview exited") },
    level: 3
  )
}
