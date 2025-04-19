import SwiftUI

struct AppCoordinatorView: View {
    @StateObject
    private var coordinator = AppCoordinator()
    
    var body: some View {
        VStack {
            switch coordinator.currentView {
            case .preloader:
                preloarerView()
            case .tabbar:
                TabBarView()
                    .transition(.opacity)
            }
        }
        .animation(.easeIn(duration: 0.3), value: coordinator.currentView)
    }
    
    @ViewBuilder
    private func preloarerView() -> some View {
        PreloaderView() {
            coordinator.chooseView(.tabbar)
        }
    }
}

#Preview {
    AppCoordinatorView()
}
