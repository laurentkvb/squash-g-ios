import SwiftUI
import SwiftData

struct MatchDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    let match: MatchRecord
    @State private var showDeleteConfirmation = false
    
    var isPlayerAWinner: Bool {
        match.scoreA > match.scoreB
    }
    
    var isPlayerBWinner: Bool {
        match.scoreB > match.scoreA
    }
    
    var body: some View {
        ZStack {
                SquashGColors.appBackgroundGradient
                    .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Date
                    VStack(spacing: 8) {
                        Text("Match Date")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.white.opacity(0.6))
                        
                        Text(match.date.formatted())
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .padding(.top, 20)
                    
                    // Score Card
                    VStack(spacing: 24) {
                        HStack(alignment: .center, spacing: 32) {
                            // Player A
                            VStack(spacing: 12) {
                                Text(match.playerA.name)
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                                
                                Text("\(match.scoreA)")
                                    .font(.system(size: 56, weight: .heavy))
                                    .foregroundColor(isPlayerAWinner ? SquashGColors.neonCyan : SquashGColors.textSecondary)
                                    .monospacedDigit()
                                
                                if isPlayerAWinner {
                                    HStack(spacing: 6) {
                                        Image(systemName: "crown.fill")
                                            .font(.system(size: 14))
                                        Text("Winner")
                                            .font(.system(size: 13, weight: .semibold))
                                    }
                                    .foregroundColor(SquashGColors.goldAccent)
                                } else {
                                    // Invisible spacer to keep alignment
                                    HStack(spacing: 6) {
                                        Image(systemName: "crown.fill")
                                            .font(.system(size: 14))
                                        Text("Winner")
                                            .font(.system(size: 13, weight: .semibold))
                                    }
                                    .foregroundColor(.clear)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            
                            Rectangle()
                                .fill(.white.opacity(0.2))
                                .frame(width: 2, height: 120)
                            
                            // Player B
                            VStack(spacing: 12) {
                                Text(match.playerB.name)
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                                
                                Text("\(match.scoreB)")
                                    .font(.system(size: 56, weight: .heavy))
                                    .foregroundColor(isPlayerBWinner ? SquashGColors.neonCyan : SquashGColors.textSecondary)
                                    .monospacedDigit()
                                
                                if isPlayerBWinner {
                                    HStack(spacing: 6) {
                                        Image(systemName: "crown.fill")
                                            .font(.system(size: 14))
                                        Text("Winner")
                                            .font(.system(size: 13, weight: .semibold))
                                    }
                                    .foregroundColor(SquashGColors.goldAccent)
                                } else {
                                    // Invisible spacer to keep alignment
                                    HStack(spacing: 6) {
                                        Image(systemName: "crown.fill")
                                            .font(.system(size: 14))
                                        Text("Winner")
                                            .font(.system(size: 13, weight: .semibold))
                                    }
                                    .foregroundColor(.clear)
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.vertical, 24)
                    .squashGCard()
                    
                    // ELO Changes
                    VStack(spacing: 16) {
                        Text("ELO Rating Changes")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.6))
                        
                        HStack(spacing: 32) {
                            VStack(spacing: 8) {
                                Text(match.playerA.name)
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundColor(.white.opacity(0.7))
                                
                                Text(match.eloChangeA >= 0 ? "+\(match.eloChangeA)" : "\(match.eloChangeA)")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(match.eloChangeA >= 0 ? SquashGColors.goldAccent : SquashGColors.neonPink)
                            }
                            .frame(maxWidth: .infinity)
                            
                            VStack(spacing: 8) {
                                Text(match.playerB.name)
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundColor(.white.opacity(0.7))
                                
                                Text(match.eloChangeB >= 0 ? "+\(match.eloChangeB)" : "\(match.eloChangeB)")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(match.eloChangeB >= 0 ? SquashGColors.goldAccent : SquashGColors.neonPink)
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(20)
                    .squashGCard(glowColor: SquashGColors.neonTeal)
                    
                    // Notes
                    if let notes = match.notes, !notes.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Notes")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white.opacity(0.6))
                            
                            Text(notes)
                                .font(.system(size: 15, weight: .regular))
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(20)
                        .squashGCard()
                    }
                    
                    // Delete Button
                    Button(action: {
                        showDeleteConfirmation = true
                    }) {
                        HStack {
                            Image(systemName: "trash.fill")
                                .font(.system(size: 16))
                            
                            Text("Delete Match")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .squashGNeonButton(borderColor: SquashGColors.neonPink.opacity(0.5))
                    }
                }
                .padding(20)
                .padding(.bottom, 100)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .confirmationDialog("Delete Match?", isPresented: $showDeleteConfirmation) {
            Button("Delete", role: .destructive) {
                deleteMatch()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This action cannot be undone. ELO ratings will not be reverted.")
        }
    }
    
    private func deleteMatch() {
        modelContext.delete(match)
        try? modelContext.save()
        dismiss()
    }
}

#Preview {
    NavigationStack {
        MatchDetailView(
            match: MatchRecord(
                playerA: Player(name: "John Doe", eloRating: 1450),
                playerB: Player(name: "Jane Smith", eloRating: 1380),
                scoreA: 11,
                scoreB: 9,
                date: Date(),
                notes: "Great match!",
                eloChangeA: 24,
                eloChangeB: -24
            )
        )
    }
    .modelContainer(for: [Player.self, MatchRecord.self])
}
