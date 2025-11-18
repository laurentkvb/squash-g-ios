import SwiftUI
import SwiftData

struct HistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \MatchRecord.date, order: .reverse) private var matches: [MatchRecord]
    @State private var showManualSet = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                SquashGColors.appBackgroundGradient
                    .ignoresSafeArea()
                
                if matches.isEmpty {
                    // Empty State
                    VStack(spacing: 16) {
                        Image(systemName: "clock.arrow.circlepath")
                            .font(.system(size: 60))
                            .foregroundColor(.white.opacity(0.3))
                        
                        Text("No match history")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white.opacity(0.6))
                        
                        Text("Start playing to track matches")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.white.opacity(0.4))
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(matches) { match in
                                NavigationLink(destination: MatchDetailView(match: match)) {
                                    MatchRowView(match: match, highlightPlayer: nil)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(20)
                        .padding(.bottom, 100)
                    }
                }
                
                // Add Manual Set moved to top-right toolbar
            }
            .centeredNavTitle("History")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showManualSet = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(SquashGColors.neonCyan)
                            .padding(8)
                    }
                }
            }
            .sheet(isPresented: $showManualSet) {
                ManualSetView()
            }
        }
    }
}

struct MatchRowView: View {
    let match: MatchRecord
    let highlightPlayer: Player?
    
    var isPlayerAWinner: Bool {
        match.scoreA > match.scoreB
    }
    
    var isPlayerBWinner: Bool {
        match.scoreB > match.scoreA
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Date
            Text(match.date.formatted())
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.white.opacity(0.4))
            
            // Players and Score
            HStack(spacing: 16) {
                // Player A
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 6) {
                        Text(match.playerA.name)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                        
                        if isPlayerAWinner {
                            Image(systemName: "crown.fill")
                                .font(.system(size: 12))
                                .foregroundColor(.yellow)
                        }
                    }
                    
                    // ELO Change
                    if match.eloChangeA != 0 {
                        Text(match.eloChangeA > 0 ? "+\(match.eloChangeA)" : "\(match.eloChangeA)")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(match.eloChangeA > 0 ? .green : .red.opacity(0.7))
                    }
                }
                
                Spacer()
                
                // Score
                HStack(spacing: 12) {
                    Text("\(match.scoreA)")
                        .font(.system(size: 32, weight: .heavy))
                        .foregroundColor(isPlayerAWinner ? SquashGColors.neonCyan : .white.opacity(0.5))
                    
                    Text("–")
                        .font(.system(size: 24, weight: .light))
                        .foregroundColor(.white.opacity(0.3))
                    
                    Text("\(match.scoreB)")
                        .font(.system(size: 32, weight: .heavy))
                        .foregroundColor(isPlayerBWinner ? SquashGColors.neonCyan : .white.opacity(0.5))
                }
                
                Spacer()
                
                // Player B
                VStack(alignment: .trailing, spacing: 6) {
                    HStack(spacing: 6) {
                        if isPlayerBWinner {
                            Image(systemName: "crown.fill")
                                .font(.system(size: 12))
                                .foregroundColor(.yellow)
                        }
                        
                        Text(match.playerB.name)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    
                    // ELO Change
                    if match.eloChangeB != 0 {
                        Text(match.eloChangeB > 0 ? "+\(match.eloChangeB)" : "\(match.eloChangeB)")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(match.eloChangeB > 0 ? .green : .red.opacity(0.7))
                    }
                }
            }
            
            // Notes
            if let notes = match.notes, !notes.isEmpty {
                Text(notes)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(.white.opacity(0.6))
                    .lineLimit(2)
            }
        }
        .padding(16)
        .squashGCard()
    }
}

#Preview {
    HistoryView()
        .modelContainer(for: [Player.self, MatchRecord.self])
}
