
import Foundation
import SwiftData
import Combine

@MainActor
class PlayerDetailViewModel: ObservableObject {
    let player: Player
    @Published var stats: PlayerStats
    
    init(player: Player, stats: PlayerStats) {
        self.player = player
        self.stats = stats
    }
    
    func refreshStats(modelContext: ModelContext) {
        // Fetch all matches and filter in-memory to avoid complex Predicate expressions
        let playerId = player.id
        let descriptor = FetchDescriptor<MatchRecord>()
        let allMatches: [MatchRecord]
        do {
            allMatches = try modelContext.fetch(descriptor)
        } catch {
            allMatches = []
        }
        let matches = allMatches.filter { m in
            m.playerA.id == playerId || m.playerB.id == playerId
        }

        var wins = 0
        for match in matches {
            let isPlayerA = match.playerA.id == playerId
            let isPlayerB = match.playerB.id == playerId
            let playerAWon = isPlayerA && match.scoreA > match.scoreB
            let playerBWon = isPlayerB && match.scoreB > match.scoreA
            if playerAWon || playerBWon {
                wins += 1
            }
        }
        
        let losses = matches.count - wins
        let winRate = matches.count > 0 ? Double(wins) / Double(matches.count) * 100 : 0
        
        stats = PlayerStats(
            matchesPlayed: matches.count,
            wins: wins,
            losses: losses,
            winRate: winRate
        )
    }
    
    func getMatches(modelContext: ModelContext) -> [MatchRecord] {
        // Fetch all matches and filter & sort in-memory
        let playerId = player.id
        let descriptor = FetchDescriptor<MatchRecord>()
        let allMatches: [MatchRecord]
        do {
            allMatches = try modelContext.fetch(descriptor)
        } catch {
            allMatches = []
        }
        let matches = allMatches.filter { m in
            m.playerA.id == playerId || m.playerB.id == playerId
        }
        return matches.sorted { $0.date > $1.date }
    }
}
