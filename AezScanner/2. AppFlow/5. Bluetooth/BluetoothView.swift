import SwiftUI

struct BluetoothView: View {
    @StateObject
    private var bluetoothManager = BluetoothManager()
    
    var body: some View {
        NavigationView {
            VStack {
                scanButton
                deviceList
            }
            .navigationTitle("Bluetooth Scanner")
        }
    }
    
    private var scanButton: some View {
        Button(action: {
            if bluetoothManager.isScanning {
                bluetoothManager.stopScan()
            } else {
                bluetoothManager.startScan()
            }
        }) {
            Text(bluetoothManager.isScanning ? "Stop Scan" : "Start Scan")
                .padding()
                .frame(maxWidth: .infinity)
                .background(bluetoothManager.isScanning ? Color.red : Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding()
        }
    }
    
    private var deviceList: some View {
        List(bluetoothManager.devices) { device in
            DeviceRow(device: device)
                .onTapGesture {
                    if device.state == .connected {
                        bluetoothManager.disconnect(from: device)
                    } else {
                        bluetoothManager.connect(to: device)
                    }
                }
        }
        .listStyle(PlainListStyle())
    }
}



#Preview {
    BluetoothView()
}
