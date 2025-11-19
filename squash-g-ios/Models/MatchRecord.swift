import Foundation
import SwiftData

@Model
class MatchRecord {
    var id: UUID
    var playerA: Player
    var playerB: Player
    var scoreA: Int
    var scoreB: Int
    var date: Date
    var notes: String?
    var eloChangeA: Int
    var eloChangeB: Int
    var duration: TimeInterval = 0
    
    // Multi-set support
    var matchMode: String = MatchMode.bestOf1.rawValue
    var setScoresData: Data? = nil
    var isAbandoned: Bool = false
    var abandonReason: String? = nil
    
    // Computed property
    @Transient
    var winner: Player? {
        if scoreA > scoreB {
            return playerA
        } else if scoreB > scoreA {
            return playerB
        }
        return nil
    }
    
    @Transient
    var setScores: [SetScoreRecord] {
        get {
            guard let data = setScoresData else { return [] }
            return (try? JSONDecoder().decode([SetScoreRecord].self, from: data)) ?? []
        }
        set {
            setScoresData = try? JSONEncoder().encode(newValue)
        }
    }
    
    init(id: UUID = UUID(),
         playerA: Player,
         playerB: Player,
         scoreA: Int,
         scoreB: Int,
         date: Date = .now,
         notes: String? = nil,
         eloChangeA: Int = 0,
         eloChangeB: Int = 0,
         duration: TimeInterval = 0,
         matchMode: MatchMode = .bestOf1,
         setScores: [SetScoreRecord] = [],
         isAbandoned: Bool = false,
         abandonReason: String? = nil) {
        self.id = id
        self.playerA = playerA
        self.playerB = playerB
        self.scoreA = scoreA
        self.scoreB = scoreB
        self.date = date
        self.notes = notes
        self.eloChangeA = eloChangeA
        self.eloChangeB = eloChangeB
        self.duration = duration
        self.matchMode = matchMode.rawValue
        self.setScoresData = try? JSONEncoder().encode(setScores)
        self.isAbandoned = isAbandoned
        self.abandonReason = abandonReason
    }
}

struct SetScoreRecord: Codable, Identifiable {
    var id = UUID()
    var setNumber: Int
    var scoreA: Int
    var scoreB: Int
    var winner: String
    var pointHistory: [PointRecord] = []
}

struct PointRecord: Codable, Identifiable {
    var id = UUID()
    var scoreA: Int
    var scoreB: Int
    var timestamp: Date = Date()
}
