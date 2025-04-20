import SwiftUI

struct BluetoothDeviceList: View {
    let devices: [BluetoothDevice]
    
    var body: some View {
        List(devices) { item in
            DeviceRow(device: item)
        }
        .listStyle(PlainListStyle())
    }
}
