import Foundation
import Combine

final class BluetoothViewModel: ObservableObject {
    private let bluetoothManager: BluetoothManager = .shared
    private let sessionStorageService: SessionStorageService = .shared
    
    let scanDuration: TimeInterval = 5
    
    @Published
    var isScanning: Bool = false
    @Published
    var devices: [BluetoothDevice] = []
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        observeIsScanning()
        observeDevices()
    }
    
    func startScan() {
        bluetoothManager.startScan()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + scanDuration) {
            self.bluetoothManager.stopScan()
            self.sessionStorageService.addNewSession(sessionType: .bluetooth, bluetoothDevices: self.devices)
        }
    }
    
    func connect(to device: BluetoothDevice) {
        bluetoothManager.connect(to: device)
    }
    
    func disconnect(from device: BluetoothDevice) {
        bluetoothManager.disconnect(from: device)
    }
    
    private func observeIsScanning() {
        bluetoothManager
            .$isScanning
            .sink { [weak self] in
                self?.isScanning = $0
            }
            .store(in: &cancellables)
    }
    
    private func observeDevices() {
        bluetoothManager
            .$devices
            .sink { [weak self] in
                self?.devices = $0
            }
            .store(in: &cancellables)
    }
}
