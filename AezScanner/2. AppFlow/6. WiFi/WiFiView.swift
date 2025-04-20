import SwiftUI
import Network

struct LanView: View {
    @StateObject
    private var viewModel = WiFiViewModel()
    
    @State
    private var showWiFiAlert = false
    
    private let monitor = NWPathMonitor()

    var body: some View {
        NavigationView {
            VStack {
                scanButton()
                managerViews()
            }
            .navigationTitle("LAN Сканер")
            .alert("Wi-Fi is turned off", isPresented: $showWiFiAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Please enable Wi-Fi to scan your local network.")
            }
        }
        .navigationViewStyle(.stack)
    }

    @ViewBuilder
    private func managerViews() -> some View {
        if viewModel.devices.isEmpty {
            description()
        } else {
            if viewModel.isScanning {
                loadView()
            } else {
                LanDeviceList(devices: viewModel.devices)
            }
        }
    }

    @ViewBuilder
    private func description() -> some View {
        Text("Press the start button to scan your local Wi-Fi network")
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    @ViewBuilder
    private func loadView() -> some View {
        VStack {
            LottieView(animationName: "Sync", loopMode: .loop)
                .frame(width: 150, height: 150)

            ProgressLineView(duration: viewModel.scanDuration)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    @ViewBuilder
    private func scanButton() -> some View {
        Button(action: {
            checkWiFiAndStartScan()
        }) {
            Text(buttonText())
                .padding()
                .frame(maxWidth: .infinity)
                .background(viewModel.isScanning ? .gray : .customPurple)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .padding()
        .disabled(viewModel.isScanning)
    }

    private func buttonText() -> String {
        viewModel.isScanning
        ? "Scanning..."
        : viewModel.devices.isEmpty ? "Start Scan" : "Rescan"
    }

    private func checkWiFiAndStartScan() {
        let monitor = NWPathMonitor(requiredInterfaceType: .wifi)
        let queue = DispatchQueue(label: "Monitor")
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                DispatchQueue.main.async {
                    viewModel.startScan()
                }
            } else {
                DispatchQueue.main.async {
                    showWiFiAlert = true
                }
            }
            monitor.cancel()
        }
        monitor.start(queue: queue)
    }
}
