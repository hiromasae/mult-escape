import SwiftUI

struct ContentView: View {
  @State private var screen: Screen = .title
  @State private var selectedLevel: Int?
  @AppStorage("unlockedLevel") private var unlockedLevel: Int = 1

  enum Screen {
    case title
    case levelSelect
    case levelPlaying
  }

  var body: some View {
    switch screen {
    case .title:
      TitleView(onStart: {
        screen = .levelSelect
      })

    case .levelSelect:
      LevelSelectView(
        onSelectLevel: { level in
          selectedLevel = level
          screen = .levelPlaying
        },
        unlockedLevel: unlockedLevel
      )
      .id(unlockedLevel)

    case .levelPlaying:
      if let level = selectedLevel {
        switch level {
        case 1:
          Level1CoordinatorView(
            onComplete: {
              if unlockedLevel < 2 { unlockedLevel = 2 }
              screen = .levelSelect
              selectedLevel = nil
            },
            onExit: {
              screen = .levelSelect
              selectedLevel = nil
            }
          )
        case 2:
          Level2CoordinatorView(
            onComplete: {
              if unlockedLevel < 3 { unlockedLevel = 3 }
              screen = .levelSelect
              selectedLevel = nil
            },
            onExit: {
              screen = .levelSelect
              selectedLevel = nil
            }
          )
        case 3:
          Level3CoordinatorView(
            onComplete: {
              if unlockedLevel < 4 { unlockedLevel = 4 }
              screen = .levelSelect
              selectedLevel = nil
            },
            onExit: {
              screen = .levelSelect
              selectedLevel = nil
            }
          )
        case 4:
          Level4CoordinatorView(
            onComplete: {
              if unlockedLevel < 5 { unlockedLevel = 5 }
              screen = .levelSelect
              selectedLevel = nil
            },
            onExit: {
              screen = .levelSelect
              selectedLevel = nil
            }
          )
        case 5:
          Level5CoordinatorView(
            onComplete: {
              screen = .levelSelect
              selectedLevel = nil
            },
            onExit: {
              screen = .levelSelect
              selectedLevel = nil
            }
          )
        default:
          VStack(spacing: 20) {
            Text("🚧 Level \(level) not implemented yet.")
              .font(.title)
              .padding()

            Button("Back to Levels") {
              screen = .levelSelect
              selectedLevel = nil
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
          }
        }
      } else {
        Text("Error: No level selected.")
      }
    }
  }
}

#Preview {
  ContentView()
}
