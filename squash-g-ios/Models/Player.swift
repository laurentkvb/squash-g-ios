import Foundation
import SwiftData

@Model
class Player {
    var id: UUID
    var name: String
    var avatarData: Data?
    var eloRating: Int
    var createdAt: Date
    
    // Computed properties for stats
    @Transient
    var matchesPlayed: Int {
        // Will be calculated from MatchRecord queries
        0
    }
    
    @Transient
    var wins: Int {
        // Will be calculated from MatchRecord queries
        0
    }
    
    @Transient
    var losses: Int {
        // Will be calculated from MatchRecord queries
        0
    }
    
    @Transient
    var winRate: Double {
        guard matchesPlayed > 0 else { return 0 }
        return Double(wins) / Double(matchesPlayed) * 100
    }
    
    init(id: UUID = UUID(),
         name: String,
         avatarData: Data? = nil,
         eloRating: Int = 1200,
         createdAt: Date = .now) {
        self.id = id
        self.name = name
        self.avatarData = avatarData
        self.eloRating = eloRating
        self.createdAt = createdAt
    }
}
