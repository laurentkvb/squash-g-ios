import Foundation

enum MatchMode: String, Codable, CaseIterable {
    case bestOf1 = "Best of 1"
    case bestOf3 = "Best of 3"
    case bestOf5 = "Best of 5"
    
    var setsToWin: Int {
        switch self {
        case .bestOf1: return 1
        case .bestOf3: return 2
        case .bestOf5: return 3
        }
    }
    
    var totalSets: Int {
        switch self {
        case .bestOf1: return 1
        case .bestOf3: return 3
        case .bestOf5: return 5
        }
    }
}

struct MatchSettings: Codable, Equatable {
    var matchMode: MatchMode = .bestOf1
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
