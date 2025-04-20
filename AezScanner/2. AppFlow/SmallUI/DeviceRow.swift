import SwiftUI

struct DeviceRow: View {
    let device: BluetoothDevice
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(device.name)
                    .font(.headline)
                Spacer()
                Text("\(device.rssi) dBm")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Text(device.id.uuidString)
                .font(.caption)
                .foregroundColor(.gray)
                .lineLimit(1)
            
            HStack {
                Text("Status:")
                Text(device.stateDescription)
                    .foregroundColor(stateColor)
            }
            .font(.caption)
        }
        .padding(.vertical, 8)
    }
    
    private var stateColor: Color {
        switch device.state {
        case .connected:
            return .green
        case .connecting:
            return .orange
        case .disconnected:
            return .red
        case .disconnecting:
            return .yellow
        case .unknown:
            return . blue
        @unknown default:
            return .gray
        }
    }
}
