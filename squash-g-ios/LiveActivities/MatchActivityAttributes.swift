import ActivityKit
import Foundation

struct MatchActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var scoreA: Int
        var scoreB: Int
        var startDate: Date
    }
    
    var playerAName: String
    var playerBName: String
}
