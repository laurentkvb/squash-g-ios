import SwiftUI
import SwiftData

struct MatchDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    let match: MatchRecord
    @State private var showDeleteConfirmation = false
    @State private var expandedSetId: UUID? = nil
    
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
                    // Date and Match Info
                    VStack(spacing: 8) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Match Date")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(.white.opacity(0.6))
                                
                                Text(match.date.formatted())
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 4) {
                                if let mode = MatchMode(rawValue: match.matchMode) {
                                    Text(mode.rawValue)
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundColor(SquashGColors.neonCyan)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(
                                            Capsule()
                                                .fill(SquashGColors.neonCyan.opacity(0.15))
                                        )
                                }
                                
                                if match.duration > 0 {
                                    HStack(spacing: 4) {
                                        Image(systemName: "clock.fill")
                                            .font(.system(size: 11))
                                        Text(TimeInterval(match.duration).toDurationString())
                                            .font(.system(size: 13, weight: .semibold))
                                    }
                                    .foregroundColor(.white.opacity(0.7))
                                }
                            }
                        }
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
                    
                    // Set Scores Breakdown (for multi-set matches)
                    if !match.setScores.isEmpty {
                        VStack(spacing: 16) {
                            HStack {
                                Text("Set Scores")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.white.opacity(0.6))
                                
                                Spacer()
                                
                                Text("Tap to expand")
                                    .font(.system(size: 12, weight: .regular))
                                    .foregroundColor(.white.opacity(0.4))
                                    .italic()
                            }
                            
                            VStack(spacing: 10) {
                                ForEach(match.setScores) { setScore in
                                    VStack(spacing: 0) {
                                        // Set Header (tappable)
                                        Button(action: {
                                            withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                                                if expandedSetId == setScore.id {
                                                    expandedSetId = nil
                                                } else {
                                                    expandedSetId = setScore.id
                                                }
                                            }
                                            HapticService.shared.selection()
                                        }) {
                                            HStack(spacing: 16) {
                                                // Expand indicator
                                                Image(systemName: expandedSetId == setScore.id ? "chevron.down" : "chevron.right")
                                                    .font(.system(size: 12, weight: .semibold))
                                                    .foregroundColor(SquashGColors.neonCyan.opacity(0.6))
                                                    .frame(width: 16)
                                                
                                                // Set Number
                                                Text("Set \(setScore.setNumber)")
                                                    .font(.system(size: 13, weight: .medium))
                                                    .foregroundColor(.white.opacity(0.5))
                                                    .frame(width: 50, alignment: .leading)
                                                
                                                // Player A Score
                                                Text("\(setScore.scoreA)")
                                                    .font(.system(size: 18, weight: .bold))
                                                    .foregroundColor(setScore.winner == "A" ? SquashGColors.neonCyan : .white.opacity(0.4))
                                                    .monospacedDigit()
                                                    .frame(width: 40)
                                                
                                                Text("–")
                                                    .font(.system(size: 16, weight: .light))
                                                    .foregroundColor(.white.opacity(0.3))
                                                
                                                // Player B Score
                                                Text("\(setScore.scoreB)")
                                                    .font(.system(size: 18, weight: .bold))
                                                    .foregroundColor(setScore.winner == "B" ? SquashGColors.neonCyan : .white.opacity(0.4))
                                                    .monospacedDigit()
                                                    .frame(width: 40)
                                                
                                                Spacer()
                                                
                                                // Winner Indicator
                                                if setScore.winner == "A" || setScore.winner == "B" {
                                                    Image(systemName: "checkmark.circle.fill")
                                                        .font(.system(size: 16))
                                                        .foregroundColor(SquashGColors.neonCyan)
                                                }
                                            }
                                            .padding(.vertical, 12)
                                            .padding(.horizontal, 12)
                                            .background(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .fill(Color.white.opacity(0.03))
                                            )
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                        
                                        // Expandable Point History
                                        if expandedSetId == setScore.id && !setScore.pointHistory.isEmpty {
                                            VStack(spacing: 8) {
                                                Text("Point-by-Point Progress")
                                                    .font(.system(size: 12, weight: .medium))
                                                    .foregroundColor(.white.opacity(0.5))
                                                    .padding(.top, 12)
                                                    .padding(.bottom, 4)
                                                
                                                LazyVGrid(columns: [
                                                    GridItem(.flexible()),
                                                    GridItem(.flexible()),
                                                    GridItem(.flexible()),
                                                    GridItem(.flexible())
                                                ], spacing: 8) {
                                                    ForEach(setScore.pointHistory) { point in
                                                        HStack(spacing: 4) {
                                                            Text("\(point.scoreA)")
                                                                .font(.system(size: 12, weight: .semibold))
                                                                .foregroundColor(.white.opacity(0.8))
                                                            Text("-")
                                                                .font(.system(size: 11, weight: .light))
                                                                .foregroundColor(.white.opacity(0.3))
                                                            Text("\(point.scoreB)")
                                                                .font(.system(size: 12, weight: .semibold))
                                                                .foregroundColor(.white.opacity(0.8))
                                                        }
                                                        .monospacedDigit()
                                                        .padding(.horizontal, 8)
                                                        .padding(.vertical, 6)
                                                        .background(
                                                            RoundedRectangle(cornerRadius: 6)
                                                                .fill(Color.white.opacity(0.04))
                                                        )
                                                    }
                                                }
                                                .padding(.horizontal, 8)
                                                .padding(.bottom, 8)
                                            }
                                            .transition(.opacity.combined(with: .scale(scale: 0.95)))
                                        }
                                    }
                                }
                            }
                        }
                        .padding(20)
                        .squashGCard()
                    }
                    
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
                scoreA: 2,
                scoreB: 1,
                date: Date(),
                notes: "Great match!",
                eloChangeA: 24,
                eloChangeB: -24,
                duration: 1845,
                matchMode: .bestOf3,
                setScores: [
                    SetScoreRecord(
                        setNumber: 1,
                        scoreA: 11,
                        scoreB: 7,
                        winner: "A",
                        pointHistory: [
                            PointRecord(scoreA: 0, scoreB: 0),
                            PointRecord(scoreA: 1, scoreB: 0),
                            PointRecord(scoreA: 1, scoreB: 1),
                            PointRecord(scoreA: 2, scoreB: 1),
                            PointRecord(scoreA: 3, scoreB: 1),
                            PointRecord(scoreA: 3, scoreB: 2),
                            PointRecord(scoreA: 4, scoreB: 2),
                            PointRecord(scoreA: 5, scoreB: 2),
                            PointRecord(scoreA: 5, scoreB: 3),
                            PointRecord(scoreA: 6, scoreB: 3),
                            PointRecord(scoreA: 7, scoreB: 3),
                            PointRecord(scoreA: 8, scoreB: 3),
                            PointRecord(scoreA: 8, scoreB: 4),
                            PointRecord(scoreA: 9, scoreB: 4),
                            PointRecord(scoreA: 9, scoreB: 5),
                            PointRecord(scoreA: 10, scoreB: 5),
                            PointRecord(scoreA: 10, scoreB: 6),
                            PointRecord(scoreA: 11, scoreB: 6),
                            PointRecord(scoreA: 11, scoreB: 7)
                        ]
                    ),
                    SetScoreRecord(
                        setNumber: 2,
                        scoreA: 9,
                        scoreB: 11,
                        winner: "B",
                        pointHistory: [
                            PointRecord(scoreA: 0, scoreB: 0),
                            PointRecord(scoreA: 0, scoreB: 1),
                            PointRecord(scoreA: 1, scoreB: 1),
                            PointRecord(scoreA: 2, scoreB: 1),
                            PointRecord(scoreA: 2, scoreB: 2),
                            PointRecord(scoreA: 3, scoreB: 2),
                            PointRecord(scoreA: 3, scoreB: 3),
                            PointRecord(scoreA: 4, scoreB: 3),
                            PointRecord(scoreA: 4, scoreB: 4),
                            PointRecord(scoreA: 5, scoreB: 4),
                            PointRecord(scoreA: 5, scoreB: 5),
                            PointRecord(scoreA: 6, scoreB: 5),
                            PointRecord(scoreA: 6, scoreB: 6),
                            PointRecord(scoreA: 7, scoreB: 6),
                            PointRecord(scoreA: 7, scoreB: 7),
                            PointRecord(scoreA: 8, scoreB: 7),
                            PointRecord(scoreA: 8, scoreB: 8),
                            PointRecord(scoreA: 9, scoreB: 8),
                            PointRecord(scoreA: 9, scoreB: 9),
                            PointRecord(scoreA: 9, scoreB: 10),
                            PointRecord(scoreA: 9, scoreB: 11)
                        ]
                    ),
                    SetScoreRecord(
                        setNumber: 3,
                        scoreA: 11,
                        scoreB: 6,
                        winner: "A",
                        pointHistory: [
                            PointRecord(scoreA: 0, scoreB: 0),
                            PointRecord(scoreA: 1, scoreB: 0),
                            PointRecord(scoreA: 2, scoreB: 0),
                            PointRecord(scoreA: 3, scoreB: 0),
                            PointRecord(scoreA: 3, scoreB: 1),
                            PointRecord(scoreA: 4, scoreB: 1),
                            PointRecord(scoreA: 5, scoreB: 1),
                            PointRecord(scoreA: 5, scoreB: 2),
                            PointRecord(scoreA: 6, scoreB: 2),
                            PointRecord(scoreA: 7, scoreB: 2),
                            PointRecord(scoreA: 7, scoreB: 3),
                            PointRecord(scoreA: 8, scoreB: 3),
                            PointRecord(scoreA: 8, scoreB: 4),
                            PointRecord(scoreA: 9, scoreB: 4),
                            PointRecord(scoreA: 10, scoreB: 4),
                            PointRecord(scoreA: 10, scoreB: 5),
                            PointRecord(scoreA: 11, scoreB: 5),
                            PointRecord(scoreA: 11, scoreB: 6)
                        ]
                    )
                ]
            )
        )
    }
    .modelContainer(for: [Player.self, MatchRecord.self])
}
