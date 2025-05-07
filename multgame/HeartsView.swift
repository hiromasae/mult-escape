import SwiftUI

struct HeartsView: View {
  var playerHearts: Int
  var maxHearts: Int = 3
  
  var body: some View {
    HStack(spacing: 5) {
      ForEach(0..<maxHearts, id: \.self) { index in
        Image(systemName: index < playerHearts ? "heart.fill" : "heart")
          .foregroundColor(.red)
          .font(.system(size: 30))
      }
    }
  }
}

#Preview {
  VStack(spacing: 20) {
    HeartsView(playerHearts: 2)  // 2/3 hearts (default)
    HeartsView(playerHearts: 4, maxHearts: 5)  // 4/5 hearts
    HeartsView(playerHearts: 7, maxHearts: 10) // 7/10 hearts
  }
}
