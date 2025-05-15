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
