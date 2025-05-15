import SwiftUI

struct HeartsView: View {
  var playerHearts: Int
  var maxHearts: Int = 3

  var body: some View {
    HStack(spacing: 5) {
      ForEach(0..<maxHearts, id: \.self) { index in
        Image(index < playerHearts ? "playerheartfull" : "playerheartempty")
          .resizable()
          .interpolation(.none)
          .scaledToFit()
          .frame(width: 40, height: 40)
      }
    }
  }
}

#Preview {
  VStack(spacing: 20) {
    HeartsView(playerHearts: 2)
    HeartsView(playerHearts: 4, maxHearts: 5)
    HeartsView(playerHearts: 7, maxHearts: 10)
  }
}
