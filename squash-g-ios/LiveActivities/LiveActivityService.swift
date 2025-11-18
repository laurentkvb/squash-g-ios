import ActivityKit
import Foundation

class LiveActivityService {
    static let shared = LiveActivityService()
    
    private var currentActivity: Activity<MatchActivityAttributes>?
    
    private init() {}
    
    func startActivity(playerAName: String, playerBName: String, startDate: Date) {
        let attributes = MatchActivityAttributes(
            playerAName: playerAName,
            playerBName: playerBName
        )
        
        let initialState = MatchActivityAttributes.ContentState(
            scoreA: 0,
            scoreB: 0,
            startDate: startDate
        )
        
        do {
            currentActivity = try Activity<MatchActivityAttributes>.request(
                attributes: attributes,
                content: .init(state: initialState, staleDate: nil),
                pushType: nil
            )
        } catch {
            print("Failed to start Live Activity: \(error)")
        }
    }
    
    func updateActivity(scoreA: Int, scoreB: Int, startDate: Date) async {
        guard let activity = currentActivity else { return }
        
        let updatedState = MatchActivityAttributes.ContentState(
            scoreA: scoreA,
            scoreB: scoreB,
            startDate: startDate
        )
        
        await activity.update(
            ActivityContent<MatchActivityAttributes.ContentState>(
                state: updatedState,
                staleDate: nil
            )
        )
    }
    
    func endActivity() async {
        guard let activity = currentActivity else { return }
        
        await activity.end(
            ActivityContent(
                state: activity.content.state,
                staleDate: nil
            ),
            dismissalPolicy: .immediate
        )
        
        currentActivity = nil
    }
}
