import SwiftUI

struct TitleView: View {
  var onStart: () -> Void
  
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
        
        Text("Mult-Escape")
          .font(.largeTitle)
          .colorInvert()
          .bold()
          .multilineTextAlignment(.center)
        
        Text("Defeat the enemy by solving multiplication problems!")
          .colorInvert()
          .multilineTextAlignment(.center)
          .padding(.horizontal)
        
        Spacer()
        
        Button(action: {
          onStart()
        }) {
          Text("Start Game")
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .padding(.horizontal)
        }
        
        Spacer()
      }
    }
  }
}

#Preview {
  TitleView(onStart: {})
}
