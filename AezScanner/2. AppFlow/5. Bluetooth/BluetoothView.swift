import SwiftUI
import CoreBluetooth

struct BluetoothView: View {
    @StateObject
    private var viewModel = BluetoothViewModel()
    
    @State
    private var showBluetoothAlert = false
    @State
    private var centralManager = CBCentralManager()
    
    var body: some View {
        NavigationView {
            VStack {
                scanButton()
                managerViews()
            }
            .navigationTitle("Bluetooth Scanner")
            .alert("Bluetooth is turned off", isPresented: $showBluetoothAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Please enable Bluetooth to scan for nearby devices.")
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
                BluetoothDeviceList(devices: viewModel.devices)
            }
        }
    }

    @ViewBuilder
    private func description() -> some View {
        Text("Press the Start button to initiate a search for Bluetooth devices nearby")
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
        Button {
            checkBluetoothAndStartScan()
        } label: {
            Text(buttonText())
                .padding()
                .frame(maxWidth: .infinity)
                .background(viewModel.isScanning ? .gray : .customPurple)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding()
        }
        .disabled(viewModel.isScanning)
    }

    private func buttonText() -> String {
        viewModel.isScanning
        ? "Scanning..."
        : viewModel.devices.isEmpty ? "Start Scan" : "Rescan"
    }

    private func checkBluetoothAndStartScan() {
        if centralManager.state == .poweredOn {
            viewModel.startScan()
        } else {
            showBluetoothAlert = true
        }
    }
}
