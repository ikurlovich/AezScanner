import SwiftUI

struct WiFiView: View {
    @StateObject
    private var scanner = LanScannerService()

    var body: some View {
        NavigationView {
            if scanner.devices.isEmpty {
                Text("Пусто")
            } else {
                List(scanner.devices) { device in
                    VStack(alignment: .leading, spacing: 4) {
                        Text("IP: \(device.ipAddress)")
                        if let mac = device.macAddress {
                            Text("MAC: \(mac)")
                        }
                        if let hostname = device.hostname {
                            Text("Name: \(hostname)")
                        }
                    }
                    .padding(.vertical, 4)
                }
                .navigationTitle("LAN Devices")
                .toolbar {
                    Button("Scan") {
                        scanner.startScanning()
                    }
                }
            }
        }
    }
}

#Preview {
    WiFiView()
}
