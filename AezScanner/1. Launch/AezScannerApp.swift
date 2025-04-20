import SwiftUI

@main
struct AezScannerApp: App {
    var body: some Scene {
        WindowGroup {
            AppCoordinatorView()
                .preferredColorScheme(.light)
        }
    }
}
