import SwiftUI

struct ProgressLineView: View {
    @State
    private var progress: CGFloat = 0.0
    
    let duration: TimeInterval
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .frame(width: geometry.size.width, height: 4)
                        .opacity(0.3)
                        .foregroundColor(Color.gray)
                    
                    Rectangle()
                        .frame(width: min(progress * geometry.size.width, geometry.size.width), height: 4)
                        .foregroundColor(Color.customPurple)
                        .animation(.linear(duration: duration), value: progress)
                }
                .cornerRadius(2)
            }
            .frame(height: 4)
        }
        .padding()
        .frame(width: 300)
        .onAppear {
            startProgress()
        }
    }
    
    private func startProgress() {
        progress = 0.0
        withAnimation(.linear(duration: duration)) {
            progress = 1.0
        }
    }
}
