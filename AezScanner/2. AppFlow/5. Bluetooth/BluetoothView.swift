import SwiftUI

struct BluetoothView: View {
    @StateObject
    private var bluetoothViewModel = BluetoothViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                scanButton()
                managerViews()
            }
            .navigationTitle("Bluetooth Scanner")
        }
        .navigationViewStyle(.stack)
    }
    
    @ViewBuilder
    private func managerViews() -> some View {
        if bluetoothViewModel.devices.isEmpty {
            description()
        } else {
            if bluetoothViewModel.isScanning {
                loadView()
            } else {
                BluetoothDeviceList(devices: bluetoothViewModel.devices)
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
            
            ProgressLineView(duration: bluetoothViewModel.scanDuration)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder
    private func scanButton() -> some View {
        Button() {
            bluetoothViewModel.startScan()
        } label: {
            Text(buttonText())
                .padding()
                .frame(maxWidth: .infinity)
                .background(bluetoothViewModel.isScanning
                            ? .red
                            : .customPurple)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding()
        }
        .disabled(bluetoothViewModel.isScanning)
    }
    
    
    
    private func buttonText() -> String {
        bluetoothViewModel.isScanning
        ? "Scanning..."
        : bluetoothViewModel.devices.isEmpty ? "Start Scan" : "Rescan"
    }
}

#Preview {
    BluetoothView()
}
