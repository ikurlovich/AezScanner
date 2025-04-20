import CoreBluetooth

//struct BluetoothDevice: Identifiable, Codable {
//    let id: UUID
//    let peripheralIdentifier: UUID
//    var name: String
//    var rssi: Int
//    var state: PeripheralState
//    
//    enum PeripheralState: String, Codable {
//        case disconnected
//        case connecting
//        case connected
//        case disconnecting
//        case unknown
//        
//        init(_ state: CBPeripheralState) {
//            switch state {
//            case .disconnected:
//                self = .disconnected
//            case .connecting:
//                self = .connecting
//            case .connected:
//                self = .connected
//            case .disconnecting:
//                self = .disconnecting
//            @unknown default:
//                self = .unknown
//            }
//        }
//    }
//    
//    init(peripheral: CBPeripheral, rssi: Int) {
//        self.id = peripheral.identifier
//        self.peripheralIdentifier = peripheral.identifier
//        self.name = peripheral.name ?? "Unknown"
//        self.rssi = rssi
//        self.state = PeripheralState(peripheral.state)
//    }
//    
//    var stateDescription: String {
//        state.rawValue.capitalized
//    }
//    
//    var cbPeripheralState: CBPeripheralState {
//        switch state {
//        case .disconnected:
//            return .disconnected
//        case .connecting:
//            return .connecting
//        case .connected:
//            return .connected
//        case .disconnecting:
//            return .disconnecting
//        case .unknown:
//            return .disconnected
//        }
//    }
//}
