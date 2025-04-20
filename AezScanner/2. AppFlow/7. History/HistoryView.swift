import SwiftUI

struct HistoryView: View {
    @StateObject
    private var historyViewModel = HistoryViewModel()
    
    @State
    private var isShowAlert: Bool = false
    @State
    private var isShowBLList: Bool = false
    
    var body: some View {
        NavigationView {
                VStack {
                    clearButton()
                    
                    if historyViewModel.sessions.isEmpty {
                        emptyStateView()
                    } else {
                        sessionsList()
                    }
                }
                .navigationTitle("History")
        }
        .navigationViewStyle(.stack)
        .alert("Delete your scan history?", isPresented: $isShowAlert) {
            Button("No", role: .cancel) { }
            Button("Yes", role: .destructive) { historyViewModel.clearHistory() }
        } message: {
            Text("This is an irreversible process, and the scan history will be cleared.")
        }
    }
    
    @ViewBuilder
    private func bluetoothSessionsList() -> some View {
        BluetoothDeviceList(devices: historyViewModel.currentSession?.bluetoothDevices ?? [])
    }
    
    @ViewBuilder
    private func lanSessionList() -> some View {
        LanDeviceList(devices: historyViewModel.currentSession?.wifiDevices ?? [])
    }
    
    @ViewBuilder
    private func sessionsList() -> some View {
        List {
            ForEach(historyViewModel.sessions) { session in
                NavigationLink {
                    if historyViewModel.currentSession?.sessionType == .bluetooth {
                        bluetoothSessionsList()
                            .navigationTitle(String(historyViewModel.currentSession?.creationDate.formatted() ?? ""))
                            .onAppear {
                                historyViewModel.chooseSession(session)
                            }
                    } else {
                        lanSessionList()
                            .navigationTitle(String(historyViewModel.currentSession?.creationDate.formatted() ?? ""))
                            .onAppear {
                                historyViewModel.chooseSession(session)
                            }
                    }
                } label: {
                    HStack {
                        Text(session.creationDate.formatted())
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("scan type:")
                            .foregroundStyle(.secondary)
                        
                        Text(session.sessionType.rawValue)
                            .foregroundStyle(.customPurple)
                    }
                }
                
            }
            .onDelete(perform: deleteSessions)
        }
        .listStyle(PlainListStyle())
    }
    
    @ViewBuilder
    private func emptyStateView() -> some View {
        VStack {
            Text("No history yet")
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    @ViewBuilder
    private func clearButton() -> some View {
        Button {
            isShowAlert.toggle()
        } label: {
            Text("Clear history")
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding()
        }
        .disabled(historyViewModel.sessions.isEmpty)
        .opacity(historyViewModel.sessions.isEmpty ? 0.5 : 1)
    }
    
    private func deleteSessions(at offsets: IndexSet) {
        offsets.forEach { index in
            let session = historyViewModel.sessions[index]
            historyViewModel.clearSession(session)
        }
    }
}

#Preview {
    HistoryView()
}
