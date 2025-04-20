import Foundation
import Combine
import CoreBluetooth
import RealmSwift


final class SessionStorageService {
    static let shared = SessionStorageService()
    
    @Published
    private(set) var sessions: [Session] = []
    
    private var cancellables: Set<AnyCancellable> = []
    private let realm = try! Realm()
    
    init() {
        loadSessions()
    }
    
    func sortedSessionsByDate() -> [Session] {
        sessions.sorted { $0.creationDate > $1.creationDate }
    }
    
    func addNewSession(sessionType: SessionType,
                       bluetoothDevices: [BluetoothDevice]? = nil,
                       wifiDevices: [WifiDevice]? = nil) {
        let newSession = Session(
            id: UUID(),
            sessionType: sessionType,
            creationDate: Date(),
            bluetoothDevices: bluetoothDevices,
            wifiDevices: wifiDevices
        )
        
        sessions.append(newSession)
        saveToRealm(session: newSession)
    }
    
    func deleteSession(_ session: Session) {
        sessions.removeAll { $0.id == session.id }

        do {
            if let realmSession = realm.object(ofType: RealmSession.self, forPrimaryKey: session.id) {
                try realm.write {
                    realm.delete(realmSession.bluetoothDevices)
                    realm.delete(realmSession.wifiDevices)
                    realm.delete(realmSession)
                }
            }
        } catch {
            print("Error deleting session from Realm: \(error)")
        }
    }

    func deleteAllSessions() {
        sessions.removeAll()

        do {
            try realm.write {
                let allSessions = realm.objects(RealmSession.self)
                let allBluetoothDevices = realm.objects(RealmBluetoothDevice.self)
                let allWifiDevices = realm.objects(RealmWifiDevice.self)
                
                realm.delete(allBluetoothDevices)
                realm.delete(allWifiDevices)
                realm.delete(allSessions)
            }
        } catch {
            print("Error deleting all sessions from Realm: \(error)")
        }
    }

    private func saveToRealm(session: Session) {
        let realmSession = RealmSession(from: session)
        do {
            try realm.write {
                realm.add(realmSession, update: .modified)
            }
        } catch {
            print("Error saving session to Realm: \(error)")
        }
    }
    
    private func loadSessions() {
        let realmSessions = realm.objects(RealmSession.self)
        self.sessions = realmSessions.map { Session(from: $0) }
    }
}
