import Foundation

final class TabBarCoordinator: ObservableObject {
    enum ViewState {
        case preloader, tabbar
    }
    
    @Published
    private(set) var currentView: Int = 1
    
    func chooseView(_ view: Int) {
        currentView = view
    }
}
