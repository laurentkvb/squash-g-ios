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
    
    struct ScoreState: Codable {
        var scoreA: Int
        var scoreB: Int
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
}
