
import Foundation
import SwiftData
import SwiftUI
import Combine

@MainActor
class ManualSetViewModel: ObservableObject {
    @Published var selectedPlayerA: Player?
    @Published var selectedPlayerB: Player?
    @Published var scoreA: String = ""
    @Published var scoreB: String = ""
    @Published var matchDate = Date()
    @Published var notes: String = ""
    @Published var showPlayerASelector = false
    @Published var showPlayerBSelector = false
    
    var isValid: Bool {
        guard let playerA = selectedPlayerA,
              let playerB = selectedPlayerB,
              playerA.id != playerB.id,
              let _ = Int(scoreA),
              let _ = Int(scoreB) else {
            return false
        }
        return true
    }
    
    func saveMatch(modelContext: ModelContext) {
        guard isValid,
              let playerA = selectedPlayerA,
              let playerB = selectedPlayerB,
              let finalScoreA = Int(scoreA),
              let finalScoreB = Int(scoreB) else {
            return
        }
        
        // Calculate ELO changes
        let eloResult = ELOService.shared.calculateNewRatings(
            ratingA: playerA.eloRating,
            ratingB: playerB.eloRating,
            scoreA: finalScoreA,
            scoreB: finalScoreB
        )
        
        // Update player ratings
        playerA.eloRating = eloResult.newRatingA
        playerB.eloRating = eloResult.newRatingB
        
        // Create match record
        let matchRecord = MatchRecord(
            playerA: playerA,
            playerB: playerB,
            scoreA: finalScoreA,
            scoreB: finalScoreB,
            date: matchDate,
            notes: notes.isEmpty ? nil : notes,
            eloChangeA: eloResult.changeA,
            eloChangeB: eloResult.changeB
        )
        
        modelContext.insert(matchRecord)
        try? modelContext.save()
        
        HapticService.shared.success()
    }
}
