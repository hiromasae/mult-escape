import SwiftUI

struct SlimeView: View {
  let frameNames: [String]
  let frameDuration: Double
  let size: CGFloat

  @State private var currentFrameIndex = 0

  var body: some View {
    Image(frameNames[currentFrameIndex])
      .interpolation(.none) 
      .resizable()
      .scaledToFit()
      .frame(width: size, height: size)
      .onAppear {
        Timer.scheduledTimer(withTimeInterval: frameDuration, repeats: true) { _ in
          currentFrameIndex = (currentFrameIndex + 1) % frameNames.count
        }
      }
  }
}
