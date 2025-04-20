import Foundation
import Combine
import CoreBluetooth
import RealmSwift


final class SessionStorageService {
    static let shared = SessionStorageService()
    
    @Published
    private(set) var sessions: [Session] = []
    
    private var cancellables: Set<AnyCancellable> = []
    private let realm = try! Realm()
    
    init() {
        loadSessions()
    }
    
    func sortedSessionsByDate() -> [Session] {
        sessions.sorted { $0.creationDate > $1.creationDate }
    }
    
    func addNewSession(sessionType: SessionType,
                       bluetoothDevices: [BluetoothDevice]? = nil,
                       wifiDevices: [WifiDevice]? = nil) {
        let newSession = Session(
            id: UUID(),
            sessionType: sessionType,
            creationDate: Date(),
            bluetoothDevices: bluetoothDevices,
            wifiDevices: wifiDevices
        )
        
        sessions.append(newSession)
        saveToRealm(session: newSession)
    }
    
    func deleteSession(_ session: Session) {
        sessions.removeAll { $0.id == session.id }

        do {
            if let realmSession = realm.object(ofType: RealmSession.self, forPrimaryKey: session.id) {
                try realm.write {
                    realm.delete(realmSession.bluetoothDevices)
                    realm.delete(realmSession.wifiDevices)
                    realm.delete(realmSession)
                }
            }
        } catch {
            print("Error deleting session from Realm: \(error)")
        }
    }

    func deleteAllSessions() {
        sessions.removeAll()

        do {
            try realm.write {
                let allSessions = realm.objects(RealmSession.self)
                let allBluetoothDevices = realm.objects(RealmBluetoothDevice.self)
                let allWifiDevices = realm.objects(RealmWifiDevice.self)
                
                realm.delete(allBluetoothDevices)
                realm.delete(allWifiDevices)
                realm.delete(allSessions)
            }
        } catch {
            print("Error deleting all sessions from Realm: \(error)")
        }
    }

    private func saveToRealm(session: Session) {
        let realmSession = RealmSession(from: session)
        do {
            try realm.write {
                realm.add(realmSession, update: .modified)
            }
        } catch {
            print("Error saving session to Realm: \(error)")
        }
    }
    
    private func loadSessions() {
        let realmSessions = realm.objects(RealmSession.self)
        self.sessions = realmSessions.map { Session(from: $0) }
    }
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

final class RealmBluetoothDevice: Object {
    @Persisted(primaryKey: true) var id: UUID
    @Persisted var peripheralIdentifier: UUID
    @Persisted var name: String
    @Persisted var rssi: Int
    @Persisted var stateRaw: String
    
    var state: BluetoothDevice.PeripheralState {
        get { BluetoothDevice.PeripheralState(rawValue: stateRaw) ?? .unknown }
        set { stateRaw = newValue.rawValue }
    }
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


extension Session {
    init(from realm: RealmSession) {
        self.id = realm.id
        self.sessionType = realm.sessionType
        self.creationDate = realm.creationDate
        self.bluetoothDevices = realm.bluetoothDevices.map { BluetoothDevice(from: $0) }
        self.wifiDevices = realm.wifiDevices.map { WifiDevice(from: $0) }
    }
}

extension BluetoothDevice {
    init(from realm: RealmBluetoothDevice) {
        self.id = realm.id
        self.peripheralIdentifier = realm.peripheralIdentifier
        self.name = realm.name
        self.rssi = realm.rssi
        self.state = realm.state
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

extension RealmBluetoothDevice {
    convenience init(from device: BluetoothDevice) {
        self.init()
        self.id = device.id
        self.peripheralIdentifier = device.peripheralIdentifier
        self.name = device.name
        self.rssi = device.rssi
        self.state = device.state
    }
}

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

struct WifiDevice: Identifiable, Codable {
    let id: UUID
    let ipAddress: String
    let hostName: String?
    let macAddress: String?
}

extension WifiDevice {
    init(from realm: RealmWifiDevice) {
        self.id = realm.id
        self.ipAddress = realm.ipAddress
        self.hostName = realm.hostName
        self.macAddress = realm.macAddress
    }
}

struct BluetoothDevice: Identifiable, Codable {
    let id: UUID
    let peripheralIdentifier: UUID
    var name: String
    var rssi: Int
    var state: PeripheralState
    
    enum PeripheralState: String, Codable {
        case disconnected
        case connecting
        case connected
        case disconnecting
        case unknown
        
        init(_ state: CBPeripheralState) {
            switch state {
            case .disconnected:
                self = .disconnected
            case .connecting:
                self = .connecting
            case .connected:
                self = .connected
            case .disconnecting:
                self = .disconnecting
            @unknown default:
                self = .unknown
            }
        }
    }
    
    init(peripheral: CBPeripheral, rssi: Int) {
        self.id = peripheral.identifier
        self.peripheralIdentifier = peripheral.identifier
        self.name = peripheral.name ?? "Unknown"
        self.rssi = rssi
        self.state = PeripheralState(peripheral.state)
    }
    
    var stateDescription: String {
        state.rawValue.capitalized
    }
    
    var cbPeripheralState: CBPeripheralState {
        switch state {
        case .disconnected:
            return .disconnected
        case .connecting:
            return .connecting
        case .connected:
            return .connected
        case .disconnecting:
            return .disconnecting
        case .unknown:
            return .disconnected
        }
    }
}
