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
    
    init(id: UUID = UUID(),
         playerA: Player,
         playerB: Player,
         scoreA: Int,
         scoreB: Int,
         date: Date = .now,
         notes: String? = nil,
         eloChangeA: Int = 0,
         eloChangeB: Int = 0,
         duration: TimeInterval = 0) {
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
    }
}
