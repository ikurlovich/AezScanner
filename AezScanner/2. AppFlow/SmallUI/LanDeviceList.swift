import SwiftUI

struct LanDeviceList: View {
    let devices: [WifiDevice]
    
    var body: some View {
        List(devices) { device in
            VStack(alignment: .leading) {
                Text("IP: \(device.ipAddress)")
                if let host = device.hostName {
                    Text("Имя хоста: \(host)")
                }
                if let mac = device.macAddress {
                    Text("MAC: \(mac)")
                }
            }
            .padding(.vertical, 4)
        }
        .listStyle(PlainListStyle())
    }
}
