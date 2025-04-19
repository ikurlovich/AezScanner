import Foundation

final class AppCoordinator: ObservableObject {
    enum ViewState {
        case preloader, tabbar
    }
    
    @Published
    private(set) var currentView: ViewState = .preloader
    
    func chooseView(_ view: ViewState) {
        currentView = view
    }
}
