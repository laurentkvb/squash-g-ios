
import Foundation
import SwiftData
import SwiftUI
import Combine

@MainActor
class ScoreboardViewModel: ObservableObject {
    @Published var match: ActiveMatch
    @Published var showWinnerScreen = false
    @Published var showSetWinBanner = false
    @Published var setWinnerName: String?
    @Published var completedSetNumber: Int?
    @Published var winnerName: String?
    @Published var eloChangeA: Int = 0
    @Published var eloChangeB: Int = 0
    
    private let activeMatchService = ActiveMatchService.shared
    let timerService = TimerService()
    private var cancellables = Set<AnyCancellable>()
    
    init(match: ActiveMatch) {
        self.match = match
        timerService.start(from: match.startDate)
        // Forward timerService updates so views observing this view model refresh
        timerService.objectWillChange
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
        // If the match already contains a winning score (e.g. restored from persistence),
        // detect and surface the winner immediately so UI can present the summary.
        checkForWinner()
    }
    
    var canUndo: Bool {
        !match.scoreHistory.isEmpty
    }
    
    func addPointToPlayerA() {
        match.addPointToPlayerA()
        activeMatchService.updateMatch(match)
        updateLiveActivity()
        HapticService.shared.light()
        checkForWinner()
    }
    
    func addPointToPlayerB() {
        match.addPointToPlayerB()
        activeMatchService.updateMatch(match)
        updateLiveActivity()
        HapticService.shared.light()
        checkForWinner()
    }
    
    func undoLastPoint() {
        match.undoLastPoint()
        activeMatchService.updateMatch(match)
        updateLiveActivity()
        HapticService.shared.selection()
    }
    
    private func updateLiveActivity() {
        Task {
            await LiveActivityService.shared.updateActivity(
                scoreA: match.scoreA,
                scoreB: match.scoreB,
                startDate: match.startDate
            )
        }
    }
    
    private func checkForWinner() {
        // Check if current set has a winner
        let result = match.settings.checkWinner(scoreA: match.scoreA, scoreB: match.scoreB)
        if result.hasWinner {
            let setWinner = result.winner ?? "A"
            
            // Complete the current set
            match.completeSet(winner: setWinner)
            activeMatchService.updateMatch(match)
            
            // Check if match is complete
            let matchResult = match.hasMatchWinner()
            if matchResult.hasWinner {
                // Match is complete
                winnerName = matchResult.winner == "A" ? match.playerAName : match.playerBName
                showWinnerScreen = true
                HapticService.shared.success()
            } else {
                // Show set win banner and continue to next set
                setWinnerName = setWinner == "A" ? match.playerAName : match.playerBName
                completedSetNumber = match.currentSetNumber - 1
                showSetWinBanner = true
                HapticService.shared.medium()
                
                // Auto-dismiss banner after 2.5 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { [weak self] in
                    withAnimation {
                        self?.showSetWinBanner = false
                    }
                }
            }
        }
    }
    
    func endAndSaveMatch(modelContext: ModelContext) {
        // Fetch players
        let descriptorA = FetchDescriptor<Player>(predicate: #Predicate { player in
            player.id == match.playerAId
        })
        let descriptorB = FetchDescriptor<Player>(predicate: #Predicate { player in
            player.id == match.playerBId
        })
        
        guard let playerA = try? modelContext.fetch(descriptorA).first,
              let playerB = try? modelContext.fetch(descriptorB).first else {
            return
        }
        
        // Calculate ELO changes
        let eloResult = ELOService.shared.calculateNewRatings(
            ratingA: playerA.eloRating,
            ratingB: playerB.eloRating,
            scoreA: match.scoreA,
            scoreB: match.scoreB
        )
        
        // Update player ratings
        playerA.eloRating = eloResult.newRatingA
        playerB.eloRating = eloResult.newRatingB
        
        // Store ELO changes for display
        eloChangeA = eloResult.changeA
        eloChangeB = eloResult.changeB
        
        // Create match record
        let duration = Date().timeIntervalSince(match.startDate)
        
        // Convert set scores to SetScoreRecord
        let setScoreRecords = match.completedSets.map { set in
            SetScoreRecord(
                setNumber: set.setNumber,
                scoreA: set.scoreA,
                scoreB: set.scoreB,
                winner: set.winner,
                pointHistory: set.pointHistory.map { point in
                    PointRecord(scoreA: point.scoreA, scoreB: point.scoreB, timestamp: point.timestamp)
                }
            )
        }

        let matchRecord = MatchRecord(
            playerA: playerA,
            playerB: playerB,
            scoreA: match.setsWonA,
            scoreB: match.setsWonB,
            date: match.startDate,
            notes: nil,
            eloChangeA: eloResult.changeA,
            eloChangeB: eloResult.changeB,
            duration: duration,
            matchMode: match.settings.matchMode,
            setScores: setScoreRecords
        )
        
        modelContext.insert(matchRecord)
        
        // Save context
        try? modelContext.save()
        
        // End Live Activity
        Task {
            await LiveActivityService.shared.endActivity()
        }
        
        // Clear active match
        activeMatchService.endMatch()
        timerService.stop()
    }
    
    func rematch() -> ActiveMatch {
        return ActiveMatch(
            playerAId: match.playerAId,
            playerBId: match.playerBId,
            playerAName: match.playerAName,
            playerBName: match.playerBName,
            scoreA: 0,
            scoreB: 0,
            startDate: Date(),
            settings: match.settings,
            scoreHistory: [],
            setsWonA: 0,
            setsWonB: 0,
            completedSets: [],
            currentSetNumber: 1
        )
    }
}
