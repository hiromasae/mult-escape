import SwiftUI

struct NumpadView: View {
  @Binding var userAnswer: String
  var onSubmit: () -> Void
  
  var body: some View {
    VStack(spacing: 10) {
      ForEach([[1,2,3],[4,5,6],[7,8,9]], id: \.self) { row in
        HStack(spacing: 10) {
          ForEach(row, id: \.self) { number in
            Button(action: {
              userAnswer.append(String(number))
            }) {
              Text("\(number)")
                .frame(width: 60, height: 60)
                .background(Color.blue)
                .foregroundColor(.white)
                .font(.title2)
                .clipShape(Circle())
            }
          }
        }
      }
      HStack(spacing: 10) {
        Button("Clear") {
          userAnswer = ""
        }
        .frame(width: 80, height: 60)
        .background(Color.gray)
        .foregroundColor(.white)
        .clipShape(Capsule())
        
        Button("0") {
          userAnswer.append("0")
        }
        .frame(width: 60, height: 60)
        .background(Color.blue)
        .foregroundColor(.white)
        .font(.title2)
        .clipShape(Circle())
        
        Button("Submit") {
          onSubmit()
        }
        .frame(width: 80, height: 60)
        .background(Color.green)
        .foregroundColor(.white)
        .clipShape(Capsule())
      }
    }
    .padding(.bottom)
  }
}
