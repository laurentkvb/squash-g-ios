import Foundation

struct ActiveMatch: Codable {
    var playerAId: UUID
    var playerBId: UUID
    var playerAName: String
    var playerBName: String
    var scoreA: Int
    var scoreB: Int
    var startDate: Date
    var settings: MatchSettings
    var scoreHistory: [ScoreState]
    
    // Multi-set support
    var setsWonA: Int = 0
    var setsWonB: Int = 0
    var completedSets: [SetScore] = []
    var currentSetNumber: Int = 1
    
    struct ScoreState: Codable {
        var scoreA: Int
        var scoreB: Int
    }
    
    struct SetScore: Codable, Identifiable {
        var id = UUID()
        var setNumber: Int
        var scoreA: Int
        var scoreB: Int
        var winner: String // "A" or "B"
        var pointHistory: [PointState] = []
    }
    
    struct PointState: Codable, Identifiable {
        var id = UUID()
        var scoreA: Int
        var scoreB: Int
        var timestamp: Date = Date()
    }
    
    mutating func addPointToPlayerA() {
        scoreHistory.append(ScoreState(scoreA: scoreA, scoreB: scoreB))
        scoreA += 1
    }
    
    mutating func addPointToPlayerB() {
        scoreHistory.append(ScoreState(scoreA: scoreA, scoreB: scoreB))
        scoreB += 1
    }
    
    mutating func undoLastPoint() {
        guard let lastState = scoreHistory.popLast() else { return }
        scoreA = lastState.scoreA
        scoreB = lastState.scoreB
    }
    
    mutating func completeSet(winner: String) {
        // Build point history from scoreHistory + final score
        var pointHistory: [PointState] = []
        pointHistory.append(PointState(scoreA: 0, scoreB: 0)) // Starting point
        
        // Add all intermediate points from scoreHistory
        for state in scoreHistory {
            pointHistory.append(PointState(scoreA: state.scoreA, scoreB: state.scoreB))
        }
        
        // Add final score if not already included
        if pointHistory.last?.scoreA != scoreA || pointHistory.last?.scoreB != scoreB {
            pointHistory.append(PointState(scoreA: scoreA, scoreB: scoreB))
        }
        
        let setScore = SetScore(
            setNumber: currentSetNumber,
            scoreA: scoreA,
            scoreB: scoreB,
            winner: winner,
            pointHistory: pointHistory
        )
        completedSets.append(setScore)
        
        if winner == "A" {
            setsWonA += 1
        } else {
            setsWonB += 1
        }
        
        // Reset scores for next set
        scoreA = 0
        scoreB = 0
        scoreHistory.removeAll()
        currentSetNumber += 1
    }
    
    func hasMatchWinner() -> (hasWinner: Bool, winner: String?) {
        let setsNeeded = settings.matchMode.setsToWin
        if setsWonA >= setsNeeded {
            return (true, "A")
        } else if setsWonB >= setsNeeded {
            return (true, "B")
        }
        return (false, nil)
    }
}
