import SwiftUI
import SwiftData

struct PlayerMatchHistoryView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    let player: Player
    
    @Query private var allMatches: [MatchRecord]
    
    init(player: Player) {
        self.player = player
        let playerId = player.id
        _allMatches = Query(
            filter: #Predicate<MatchRecord> { match in
                match.playerA.id == playerId || match.playerB.id == playerId
            },
            sort: \MatchRecord.date,
            order: .reverse
        )
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                SquashGColors.appBackgroundGradient
                    .ignoresSafeArea()
                
                if allMatches.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "clock.arrow.circlepath")
                            .font(.system(size: 60))
                            .foregroundColor(.white.opacity(0.3))
                        
                        Text("No match history")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white.opacity(0.6))
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(allMatches) { match in
                                NavigationLink(destination: MatchDetailView(match: match)) {
                                    MatchRowView(match: match, highlightPlayer: player)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(20)
                        .padding(.bottom, 100)
                    }
                }
            }
            .navigationTitle("\(player.name)'s Matches")
            .navigationBarTitleDisplayMode(.inline)
            .centeredNavTitle("\(player.name)'s Matches")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(SquashGColors.neonCyan)
                }
            }
        }
    }
}

#Preview {
    PlayerMatchHistoryView(player: Player(name: "John Doe"))
        .modelContainer(for: [Player.self, MatchRecord.self])
}
