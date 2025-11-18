import Foundation
import SwiftData
import SwiftUI
import Combine

@MainActor
class PlayersViewModel: ObservableObject {
    @Published var searchText = ""
    
    func playerStats(for player: Player, modelContext: ModelContext) -> PlayerStats {
        // Break up predicate for type-checking
        let playerId = player.id
        // Fetch all matches and filter in-memory to avoid complex Predicate expressions
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

        // Break up win logic for type-checking
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
        let winRate: Double
        if matches.count > 0 {
            winRate = Double(wins) / Double(matches.count) * 100
        } else {
            winRate = 0
        }

        return PlayerStats(
            matchesPlayed: matches.count,
            wins: wins,
            losses: losses,
            winRate: winRate
        )
    }
}

struct PlayerStats {
    let matchesPlayed: Int
    let wins: Int
    let losses: Int
    let winRate: Double
}
