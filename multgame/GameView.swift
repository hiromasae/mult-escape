import SwiftUI

struct GameView: View {
  // MARK: - Input
  var problems: [Int]
  var showHearts: Bool = true
  var onComplete: () -> Void
  var onExit: () -> Void
  let level: Int
  
  // MARK: - State
  @State private var currentProblemIndex = 0
  @State private var userAnswer = ""
  @State private var playerHearts = 3
  @State private var isPaused = false
  @State private var didWin = false
  @State private var bossShake = false
  @State private var heartShake = false
  
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
              .offset(x: heartShake ? CGFloat.random(in: -8...8) : 0)
              .animation(heartShake ? .easeInOut(duration: 0.05).repeatCount(6, autoreverses: true) :
                  .default, value: heartShake)
            Spacer()
            PauseButton {
              isPaused = true
            }
            .padding()
          }
          .frame(maxWidth: .infinity, alignment: .leading)
        }
        
        Spacer().padding(.top)
        
        HStack {
          if !didWin {
            VStack(spacing: spacingForLevel) {
              ProgressView(
                value: Double(enemyHealth),
                total: Double(problems.count)
              )
              .progressViewStyle(LinearProgressViewStyle(tint: .red))
              .frame(width: 240)
              .animation(.easeInOut, value: enemyHealth)
              .padding(.bottom, 4)
              
              SlimeView(
                frameNames: bossFrames,
                frameDuration: 0.2,
                size: 240,
                isPaused: isPaused
              )
              .offset(x: bossShake ? CGFloat.random(in: -12...12) : 0)
              .animation(bossShake ? .easeInOut(duration: 0.05).repeatCount(6, autoreverses: true) :
                  .default, value: bossShake)
            }
          }
        }
        .font(.title2)
        .padding(.horizontal)
        
        if let number = currentNumber {
          Text("1 × \(number) = \(userAnswer)")
            .font(.largeTitle).colorInvert().bold()
            .opacity(gameOver ? 0.5 : 1.0)
            .padding()
        }
        
        Spacer()
        
        if didWin {
          Text("🎉 Level Complete!")
            .font(.largeTitle)
            .foregroundColor(.white)
            .padding()
        }
        
        if playerHearts == 0 {
          Text("Game Over!")
            .font(.largeTitle)
            .foregroundColor(.red)
        }
        
        if gameOver {
          ImageButton(label: "back") {
            if didWin {
              onComplete()
            }
            else {
              onExit()
            }
          }
          Spacer()
            .padding(.bottom)
        }
        
        if !gameOver {
          NumpadView(userAnswer: $userAnswer, onSubmit: checkAnswer)
        }
      }
      .padding()
      .frame(maxHeight: .infinity, alignment: .bottom)
      
      if isPaused {
        ZStack {
          PauseMenuView(
            onResume: { isPaused = false },
            onExit: onExit
          )
          .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .zIndex(1)
      }
    }
  }
  
  // MARK: - Logic
  private func checkAnswer() {
    guard !gameOver, let number = currentNumber else { return }
    
    if let answer = Int(userAnswer), answer == 1 * number {
      bossShake = true
      withAnimation(.default) {
        currentProblemIndex += 1
      }
      // Reset shake after a brief delay
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
        bossShake = false
      }
      
      if currentProblemIndex >= problems.count {
        didWin = true
      }
    } else {
      heartShake = true
      playerHearts = max(0, playerHearts - 1)
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
        heartShake = false
      }
    }
    
    userAnswer = ""
  }
  
  private var bossFrames: [String] {
    switch level {
    case 1:
      return ["greenslimelarge1", "greenslimelarge2", "greenslimelarge3", "greenslimelarge2"]
    case 2:
      return ["blueslimelarge1", "blueslimelarge2", "blueslimelarge3", "blueslimelarge2"]
    case 3:
      return ["yellowslimelarge1", "yellowslimelarge2", "yellowslimelarge3", "yellowslimelarge2"]
    case 4:
      return ["redslimelarge1", "redslimelarge2", "redslimelarge3", "redslimelarge2"]
    case 5:
      return ["kingslime1", "kingslime2", "kingslime3", "kingslime2"]
    default:
      return ["greenslimelarge1", "greenslimelarge2", "greenslimelarge3", "greenslimelarge2"]
    }
  }
  
  private var spacingForLevel: CGFloat {
    switch level {
    case 5:
      return 0
    default:
      return -100
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
      .buttonStyle(NoEffectButtonStyle())
      .simultaneousGesture(
        DragGesture(minimumDistance: 0)
          .onChanged { _ in withAnimation(nil) { isPressed = true } }
          .onEnded { _ in withAnimation(nil) { isPressed = false } }
      )
    }
  }
  
  struct ImageButton: View {
    let label: String
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
      Button(action: action) {
        Image(isPressed ? "\(label)buttondown" : "\(label)buttonup")
          .resizable()
          .interpolation(.none)
          .scaledToFit()
          .animation(nil, value: isPressed)
          .scaleEffect(isPressed ? 0.95 : 1.0)
      }
      .buttonStyle(NoEffectButtonStyle())
      .frame(height: 80)
      .simultaneousGesture(
        DragGesture(minimumDistance: 0)
          .onChanged { _ in withAnimation(nil) { isPressed = true } }
          .onEnded { _ in withAnimation(nil) { isPressed = false } }
      )
    }
  }
  
  
  struct NoEffectButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
      configuration.label
    }
  }
}
