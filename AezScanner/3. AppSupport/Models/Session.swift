import Foundation
import RealmSwift

enum SessionType: String, Codable {
    case bluetooth = "Bluetooth"
    case wifi = "Wi-Fi"
}

struct Session: Identifiable, Codable {
    let id: UUID
    let sessionType: SessionType
    let creationDate: Date
    let bluetoothDevices: [BluetoothDevice]?
    let wifiDevices: [WifiDevice]?
}

final class RealmSession: Object {
    @Persisted(primaryKey: true) var id: UUID
    @Persisted var sessionTypeRaw: String
    @Persisted var creationDate: Date
    @Persisted var bluetoothDevices: List<RealmBluetoothDevice>
    @Persisted var wifiDevices: List<RealmWifiDevice>
    
    var sessionType: SessionType {
        get { SessionType(rawValue: sessionTypeRaw) ?? .bluetooth }
        set { sessionTypeRaw = newValue.rawValue }
    }
}

extension Session {
    init(from realm: RealmSession) {
        self.id = realm.id
        self.sessionType = realm.sessionType
        self.creationDate = realm.creationDate
        self.bluetoothDevices = realm.bluetoothDevices.map { BluetoothDevice(from: $0) }
        self.wifiDevices = realm.wifiDevices.map { WifiDevice(from: $0) }
    }
}

extension RealmSession {
    convenience init(from session: Session) {
        self.init()
        self.id = session.id
        self.sessionType = session.sessionType
        self.creationDate = session.creationDate
        
        if let btDevices = session.bluetoothDevices {
            self.bluetoothDevices.append(objectsIn: btDevices.map { RealmBluetoothDevice(from: $0) })
        }
        
        if let wifiDevices = session.wifiDevices {
            self.wifiDevices.append(objectsIn: wifiDevices.map { RealmWifiDevice(from: $0) })
        }
    }
}
