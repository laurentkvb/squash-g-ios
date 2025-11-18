
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
    @Published var activeMatch: ActiveMatch?
    
    private let activeMatchService = ActiveMatchService.shared
    private var cancellables = Set<AnyCancellable>()
    
    var hasActiveMatch: Bool {
        activeMatch != nil
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

    init() {
        // keep local activeMatch in sync with the service so views observing this view model update
        activeMatch = activeMatchService.activeMatch
        activeMatchService.$activeMatch
            .receive(on: DispatchQueue.main)
            .sink { [weak self] match in
                self?.activeMatch = match
            }
            .store(in: &cancellables)

        // Listen for cleared local data so we can reset any in-memory selections
        NotificationCenter.default.addObserver(self, selector: #selector(handleLocalDataCleared), name: .didClearLocalData, object: nil)
    }

    @objc private func handleLocalDataCleared() {
        Task { @MainActor in
            // Clear in-memory selections
            selectedPlayerA = nil
            selectedPlayerB = nil
            // Reset other transient UI state if desired
            matchSettings = MatchSettings()
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .didClearLocalData, object: nil)
    }
}
