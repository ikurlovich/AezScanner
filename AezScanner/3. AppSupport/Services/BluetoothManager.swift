import CoreBluetooth

class BluetoothManager: NSObject, ObservableObject {
    private var centralManager: CBCentralManager!
    @Published
    var devices = [BluetoothDevice]()
    @Published
    var isScanning = false
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func startScan() {
        if centralManager.state == .poweredOn {
            devices.removeAll()
            centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
            isScanning = true
        }
    }
    
    func stopScan() {
        centralManager.stopScan()
        isScanning = false
    }
    
    func connect(to device: BluetoothDevice) {
        centralManager.connect(device.peripheral, options: nil)
    }
    
    func disconnect(from device: BluetoothDevice) {
        centralManager.cancelPeripheralConnection(device.peripheral)
    }
}

extension BluetoothManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            print("Bluetooth is powered on")
        } else {
            print("Bluetooth is not available: \(central.state.rawValue)")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        let rssi = RSSI.intValue
        let device = BluetoothDevice(peripheral: peripheral, rssi: rssi)
        
        if let index = devices.firstIndex(where: { $0.id == device.id }) {
            devices[index].rssi = rssi
            devices[index].state = peripheral.state
        } else {
            devices.append(device)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        if let index = devices.firstIndex(where: { $0.id == peripheral.identifier }) {
            devices[index].state = .connected
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if let index = devices.firstIndex(where: { $0.id == peripheral.identifier }) {
            devices[index].state = .disconnected
        }
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        if let index = devices.firstIndex(where: { $0.id == peripheral.identifier }) {
            devices[index].state = .disconnected
        }
    }
}
