import Foundation
import Combine

final class HistoryViewModel: ObservableObject {
    @Published
    var currentSession: Session?
    
    @Published
    private(set) var sessions: [Session] = []
    
    private let sessionsStorage: SessionStorageService = .shared
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        observedSessions()
    }
    
    func chooseSession(_ session: Session) {
        currentSession = session
    }
    
    func clearSession(_ session: Session) {
        sessionsStorage.deleteSession(session)
    }
    
    func clearHistory() {
        sessionsStorage.deleteAllSessions()
        currentSession = nil
    }
    
    private func observedSessions() {
        sessionsStorage
            .$sessions
            .sink { [weak self] in
                self?.sessions = $0
            }
            .store(in: &cancellables)
    }
}
