
import Foundation
import SwiftData
import SwiftUI
import Combine

@MainActor
class HomeViewModel: ObservableObject {
    @Published var selectedPlayerA: Player?
    @Published var selectedPlayerB: Player?
    @Published var matchSettings = MatchSettings()
    @Published var showPlayerASelector = false
    @Published var showPlayerBSelector = false
    
    private let activeMatchService = ActiveMatchService.shared
    
    var hasActiveMatch: Bool {
        activeMatchService.activeMatch != nil
    }
    
    var activeMatch: ActiveMatch? {
        activeMatchService.activeMatch
    }
    
    var canStartMatch: Bool {
        selectedPlayerA != nil && selectedPlayerB != nil && selectedPlayerA?.id != selectedPlayerB?.id
    }
    
    func startMatch() {
        guard let playerA = selectedPlayerA,
              let playerB = selectedPlayerB else { return }
        
        activeMatchService.startMatch(
            playerAId: playerA.id,
            playerBId: playerB.id,
            playerAName: playerA.name,
            playerBName: playerB.name,
            settings: matchSettings
        )
        
        // Start Live Activity
        LiveActivityService.shared.startActivity(
            playerAName: playerA.name,
            playerBName: playerB.name,
            startDate: Date()
        )
        
        HapticService.shared.medium()
    }
    
    func loadPlayersForActiveMatch(modelContext: ModelContext) {
        guard let match = activeMatch else { return }
        
        let descriptorA = FetchDescriptor<Player>(predicate: #Predicate { player in
            player.id == match.playerAId
        })
        let descriptorB = FetchDescriptor<Player>(predicate: #Predicate { player in
            player.id == match.playerBId
        })
        
        selectedPlayerA = try? modelContext.fetch(descriptorA).first
        selectedPlayerB = try? modelContext.fetch(descriptorB).first
    }
}
