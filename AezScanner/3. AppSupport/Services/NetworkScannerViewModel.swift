import Foundation
import MMLanScan

class NetworkScannerManager: NSObject, LanScannerDelegate {
    static let shared = NetworkScannerManager()
    
    @Published
    var devices: [WifiDevice] = []
    @Published
    var isScanning = false

    private var lanScanner: LanScanner?
    private var completion: (() -> Void)?  // <-- добавили

    func startScan(completion: (() -> Void)? = nil) {
        devices.removeAll()
        isScanning = true
        self.completion = completion
        
        lanScanner = LanScanner(delegate: self)
        lanScanner?.start()
    }

    func lanScanDidFindNewDevice(_ device: LanDevice) {
        DispatchQueue.main.async {
            let newDevice = WifiDevice(
                id: UUID(),
                ipAddress: device.ipAddress,
                hostName: device.hostname,
                macAddress: device.macAddress
            )
            self.devices.append(newDevice)
        }
    }

    func lanScanDidFinishScanning(with status: LanScannerStatus) {
        DispatchQueue.main.async {
            self.isScanning = false
            self.completion?()
            self.completion = nil
        }
    }

    func lanScanDidFailedToScan() {
        DispatchQueue.main.async {
            self.isScanning = false
            self.completion?()
            self.completion = nil
        }
    }

    func lanScanDidUpdateProgress(_ progress: Float, overall: Int) {

    }
}
