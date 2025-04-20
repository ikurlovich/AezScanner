import Foundation
import CoreBluetooth
import RealmSwift

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

extension BluetoothDevice {
    init(from realm: RealmBluetoothDevice) {
        self.id = realm.id
        self.peripheralIdentifier = realm.peripheralIdentifier
        self.name = realm.name
        self.rssi = realm.rssi
        self.state = realm.state
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
