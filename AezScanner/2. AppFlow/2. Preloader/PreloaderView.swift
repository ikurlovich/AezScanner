import SwiftUI
import Lottie

struct PreloaderView: View {
    let goToMenu: () -> Void
    
    var body: some View {
        VStack {
            LottieView(animationName: "Wireless", loopMode: .loop)
                .frame(width: 200, height: 200)
            
            HStack {
                Text("AezScanner")
                    .bold()
                    .italic()
                    .foregroundStyle(.customPurple)
                    .font(.largeTitle)
                    .offset(y: -50)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.goToMenu()
            }
        }
    }
}

#Preview {
    PreloaderView(goToMenu: {})
}
