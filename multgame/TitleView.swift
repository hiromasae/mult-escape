import SwiftUI

struct TitleView: View {
  var onStart: () -> Void
  
  @State private var isPressed = false
  @State private var currentTitleIndex = 0
  @State private var fadeIn = true
  
  let titleImages = ["title1", "title2", "title3", "title4"]
  
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
        Spacer()
        Spacer()
        
        FadingImage(imageNames: titleImages, currentIndex: currentTitleIndex)
                  .frame(width: 360, height: 200)
        
        Text("An edutainment game by Hiro E.")
          .colorInvert()
          .multilineTextAlignment(.center)
          .padding(.horizontal)
        
        Spacer()
        
        Image(isPressed ? "playbuttondown" : "playbuttonup")
          .interpolation(.none)
          .resizable()
          .frame(width: 280, height: 80)
          .contentShape(Rectangle()) // Makes transparent areas tappable
          .gesture(
            DragGesture(minimumDistance: 0)
              .onChanged { _ in isPressed = true }
              .onEnded { _ in
                isPressed = false
                onStart()
              }
          )

        
        Spacer()
      }
    }
    .onAppear {
      Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
        withAnimation {
          currentTitleIndex = (currentTitleIndex + 1) % titleImages.count
        }
      }
    }
  }
}

struct FadingImage: View {
  let imageNames: [String]
  let currentIndex: Int

  @State private var scale: CGFloat = 1.0
  @State private var angle: Double = 0

  var body: some View {
    ZStack {
      Image(imageNames[currentIndex])
        .interpolation(.none)
        .resizable()
        .scaledToFit()
        .transition(.opacity)
        .id(imageNames[currentIndex])
    }
    .scaleEffect(scale)
    .rotationEffect(.degrees(angle))
    .onAppear {
      withAnimation(
        Animation.easeInOut(duration: 2)
          .repeatForever(autoreverses: true)
      ) {
        scale = 1.05
        angle = 3  // Rotate slightly to the right, will auto reverse
      }
    }
  }
}

#Preview {
  TitleView(onStart: {})
}
