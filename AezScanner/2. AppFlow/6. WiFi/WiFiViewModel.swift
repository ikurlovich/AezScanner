import Foundation
import Combine

final class WiFiViewModel: ObservableObject {
    private let networkScannerManager: NetworkScannerManager = .shared
    private let sessionStorageService: SessionStorageService = .shared
    
    let scanDuration: TimeInterval = 5
    
    @Published
    private(set) var isScanning = false
    @Published
    private(set) var devices: [WifiDevice] = []
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        observeIsScanning()
        observeDevices()
    }
    
    func startScan() {
        networkScannerManager.startScan(completion: addNewSession)
    }
    
    private func addNewSession() {
        self.sessionStorageService.addNewSession(sessionType: .wifi, wifiDevices: self.devices)
    }
    
    private func observeIsScanning() {
        networkScannerManager
            .$isScanning
            .sink { [weak self] in
                self?.isScanning = $0
            }
            .store(in: &cancellables)
    }
    
    private func observeDevices() {
        networkScannerManager
            .$devices
            .sink { [weak self] in
                self?.devices = $0
            }
            .store(in: &cancellables)
    }
}
