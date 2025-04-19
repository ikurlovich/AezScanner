import Foundation
import MMLanScan

class LanScannerService: NSObject, ObservableObject {
    @Published var devices: [DiscoveredDevice] = []
    @Published var isScanning: Bool = false
    @Published var progress: Float = 0.0

    private var lanScanner: MMLANScanner?

    override init() {
        super.init()
        lanScanner = MMLANScanner(delegate: self)
    }

    func startScanning() {
        devices.removeAll()
        progress = 0.0
        isScanning = true
        lanScanner?.start()
    }

    func stopScanning() {
        lanScanner?.stop()
        isScanning = false
        progress = 0.0
    }
}

extension LanScannerService: MMLANScannerDelegate {
    func lanScanDidFailedToScan() {
        DispatchQueue.main.async {
            self.isScanning = false
            self.progress = 0.0
        }
        print("Failed to scan: The scan process encountered an error.")
    }
    
    func lanScanDidFindNewDevice(_ device: MMDevice!) {
        let newDevice = DiscoveredDevice(
            ipAddress: device.ipAddress ?? "Unknown IP",
            macAddress: device.macAddress,
            hostname: device.hostname
        )
        DispatchQueue.main.async {
            self.devices.append(newDevice)
        }
    }

    func lanScanDidFinishScanning(with status: MMLanScannerStatus) {
        DispatchQueue.main.async {
            self.isScanning = false
        }
        print("Scanning finished with status: \(status.rawValue)")
    }

    func lanScanDidFailToScan() {
        DispatchQueue.main.async {
            self.isScanning = false
        }
        print("Failed to scan")
    }

    private func lanScanProgressPinged(_ pingedHosts: Int, from overallHosts: Int) {
        let progress = Float(pingedHosts) / Float(overallHosts)
        DispatchQueue.main.async {
            self.progress = progress
        }
    }
}
