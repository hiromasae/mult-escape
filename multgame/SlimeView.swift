import SwiftUI

struct SlimeView: View {
  let frameNames: [String]
  let frameDuration: Double
  let size: CGFloat
  var isPaused: Bool = false

  @State var currentIndex = 0
  var timer = Timer.publish(every: 0.2, on: .main, in: .common).autoconnect()

  var body: some View {
    Image(frameNames[currentIndex])
      .resizable()
      .interpolation(.none)
      .scaledToFit()
      .frame(width: size, height: size)
      .onReceive(timer) { _ in
        if !isPaused {
          currentIndex = (currentIndex + 1) % frameNames.count
        }
      }
  }
}
