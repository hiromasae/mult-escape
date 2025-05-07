import SwiftUI

struct LevelSelectView: View {
  var onSelectLevel: (Int) -> Void
  var unlockedLevel: Int

  var body: some View {
    VStack(spacing: 20) {
      Spacer()

      Text("Select a Level")
        .font(.largeTitle)
        .bold()

      ForEach(1...5, id: \.self) { level in
        Button(action: {
          onSelectLevel(level)
        }) {
          Text("Level \(level)")
            .frame(maxWidth: .infinity)
            .padding()
            .background(unlockedLevel >= level ? Color.blue : Color.gray)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .padding(.horizontal)
        }
        .disabled(unlockedLevel < level)
      }

      Spacer()
    }
    .padding()
  }
}
