
import Foundation
import Combine

class ELOService {
    static let shared = ELOService()
    
    private init() {}
    
    /// K-factor for ELO calculation
    private let kFactor: Double = 32
    
    /// Calculate expected score for player A
    private func expectedScore(ratingA: Int, ratingB: Int) -> Double {
        let exponent = Double(ratingB - ratingA) / 400.0
        return 1.0 / (1.0 + pow(10, exponent))
    }
    
    /// Calculate new ELO ratings after a match
    /// - Parameters:
    ///   - ratingA: Current ELO rating of player A
    ///   - ratingB: Current ELO rating of player B
    ///   - scoreA: Actual score of player A (higher means winner)
    ///   - scoreB: Actual score of player B
    /// - Returns: Tuple containing (newRatingA, newRatingB, changeA, changeB)
    func calculateNewRatings(ratingA: Int, ratingB: Int, scoreA: Int, scoreB: Int) -> (newRatingA: Int, newRatingB: Int, changeA: Int, changeB: Int) {
        // Determine actual score (1 for win, 0 for loss)
        let actualScoreA: Double = scoreA > scoreB ? 1.0 : 0.0
        let actualScoreB: Double = scoreB > scoreA ? 1.0 : 0.0
        
        // Calculate expected scores
        let expectedA = expectedScore(ratingA: ratingA, ratingB: ratingB)
        let expectedB = expectedScore(ratingA: ratingB, ratingB: ratingA)
        
        // Calculate rating changes
        let changeA = Int(round(kFactor * (actualScoreA - expectedA)))
        let changeB = Int(round(kFactor * (actualScoreB - expectedB)))
        
        // Calculate new ratings
        let newRatingA = ratingA + changeA
        let newRatingB = ratingB + changeB
        
        return (newRatingA, newRatingB, changeA, changeB)
    }
}
