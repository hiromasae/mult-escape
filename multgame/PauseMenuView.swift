import SwiftUI

struct PauseMenuView: View {
  var onResume: () -> Void
  var onExit: () -> Void
  
  var body: some View {
    Color.black
      .edgesIgnoringSafeArea(.all)
    
    VStack(spacing: 20) {
      Text("Game Paused")
        .font(.title)
        .foregroundColor(.white)
      
      Button("Resume") {
        onResume()
      }
      .padding()
      .frame(maxWidth: .infinity)
      .background(Color.green)
      .foregroundColor(.white)
      .clipShape(Capsule())
      .padding(.horizontal)
      
      Button("Return to Level Select") {
        onExit()
      }
      .padding()
      .frame(maxWidth: .infinity)
      .background(Color.red)
      .foregroundColor(.white)
      .clipShape(Capsule())
      .padding(.horizontal)
    }
    .padding()
  }
}
