import Foundation

struct DiscoveredDevice: Identifiable {
    let id = UUID()
    let ipAddress: String
    let macAddress: String?
    let hostname: String?
}
