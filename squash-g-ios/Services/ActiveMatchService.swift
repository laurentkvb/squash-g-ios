
import Foundation
import Combine

class ActiveMatchService: ObservableObject {
    static let shared = ActiveMatchService()
    
    @Published var activeMatch: ActiveMatch?
    
    private let userDefaultsKey = "activeMatch"
    
    private init() {
        loadActiveMatch()
    }
    
    func startMatch(playerAId: UUID, playerBId: UUID, playerAName: String, playerBName: String, settings: MatchSettings) {
        let match = ActiveMatch(
            playerAId: playerAId,
            playerBId: playerBId,
            playerAName: playerAName,
            playerBName: playerBName,
            scoreA: 0,
            scoreB: 0,
            startDate: Date(),
            settings: settings,
            scoreHistory: [],
            setsWonA: 0,
            setsWonB: 0,
            completedSets: [],
            currentSetNumber: 1
        )
        activeMatch = match
        saveActiveMatch()
    }
    
    func updateMatch(_ match: ActiveMatch) {
        activeMatch = match
        saveActiveMatch()
    }
    
    func endMatch() {
        activeMatch = nil
        clearActiveMatch()
    }
    
    private func saveActiveMatch() {
        guard let match = activeMatch else { return }
        if let encoded = try? JSONEncoder().encode(match) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
    
    private func loadActiveMatch() {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey),
              let match = try? JSONDecoder().decode(ActiveMatch.self, from: data) else {
            return
        }
        activeMatch = match
    }
    
    private func clearActiveMatch() {
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
    }
}
