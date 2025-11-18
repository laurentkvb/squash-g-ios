import Foundation

struct MatchSettings: Codable, Equatable {
    var targetScore: Int = 11
    var winByTwo: Bool = true
    var tieBreakMode: Bool = false
    
    func checkWinner(scoreA: Int, scoreB: Int) -> (hasWinner: Bool, winner: String?) {
        let effectiveTarget = tieBreakMode ? 15 : targetScore
        
        if scoreA >= effectiveTarget || scoreB >= effectiveTarget {
            if winByTwo {
                let lead = abs(scoreA - scoreB)
                if lead >= 2 {
                    return (true, scoreA > scoreB ? "A" : "B")
                }
            } else {
                return (true, scoreA > scoreB ? "A" : "B")
            }
        }
        
        return (false, nil)
    }
}
