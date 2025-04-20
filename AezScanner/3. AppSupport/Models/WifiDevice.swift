import Foundation
import RealmSwift

struct WifiDevice: Identifiable, Codable {
    let id: UUID
    let ipAddress: String
    let hostName: String?
    let macAddress: String?
}

final class RealmWifiDevice: Object {
    @Persisted(primaryKey: true) var id: UUID
    @Persisted var ipAddress: String
    @Persisted var hostName: String?
    @Persisted var macAddress: String?
    
    convenience init(from device: WifiDevice) {
        self.init()
        self.id = device.id
        self.ipAddress = device.ipAddress
        self.hostName = device.hostName
        self.macAddress = device.macAddress
    }
}

extension WifiDevice {
    init(from realm: RealmWifiDevice) {
        self.id = realm.id
        self.ipAddress = realm.ipAddress
        self.hostName = realm.hostName
        self.macAddress = realm.macAddress
    }
}
