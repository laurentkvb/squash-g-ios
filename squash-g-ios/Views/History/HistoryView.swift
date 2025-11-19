import SwiftUI
import SwiftData

struct HistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \MatchRecord.date, order: .reverse) private var matches: [MatchRecord]
    @State private var showManualSet = false
    @State private var selectedMatchForSheet: MatchRecord? = nil
    @State private var pendingDeleteMatch: MatchRecord? = nil

    var body: some View {
        NavigationStack {
            ZStack {
                SquashGColors.appBackgroundGradient
                    .ignoresSafeArea()

                if matches.isEmpty {
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
                    List {
                        ForEach(matches) { match in
                            Button {
                                selectedMatchForSheet = match
                            } label: {
                                MatchRowView(match: match, highlightPlayer: nil)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .listRowInsets(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button(role: .destructive) {
                                    pendingDeleteMatch = match
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                        .foregroundStyle(.white)
                                }
                                .tint(SquashGColors.neonPurple)
                                
                                Button {
                                    selectedMatchForSheet = match
                                } label: {
                                    Label("View", systemImage: "eye")
                                        .foregroundStyle(.white)
                                }
                                .tint(SquashGColors.neonCyan)
                            }
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    // Ensure content can scroll above the floating tab bar — add a safe-area inset
                    .safeAreaInset(edge: .bottom) {
                        Color.clear.frame(height: 140)
                    }
                    .alert("Delete match?", isPresented: Binding(get: { pendingDeleteMatch != nil }, set: { if !$0 { pendingDeleteMatch = nil } })) {
                        Button("Delete", role: .destructive) {
                            if let m = pendingDeleteMatch {
                                deleteMatch(m)
                            }
                            pendingDeleteMatch = nil
                        }
                        Button("Cancel", role: .cancel) {
                            pendingDeleteMatch = nil
                        }
                    } message: {
                        Text("This will permanently delete the match. This action cannot be undone.")
                    }
                }
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
            .sheet(item: $selectedMatchForSheet) { match in
                MatchDetailView(match: match)
            }
        }
    }

    private func deleteMatch(_ match: MatchRecord) {
        modelContext.delete(match)
    }
}

// MARK: - Match Row
struct MatchRowView: View {
    let match: MatchRecord
    let highlightPlayer: Player?

    private var isPlayerAWinner: Bool { match.scoreA > match.scoreB }
    private var isPlayerBWinner: Bool { match.scoreB > match.scoreA }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(match.date.formatted())
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.white.opacity(0.4))

                Spacer()
                
                // Match Mode Badge
                if let mode = MatchMode(rawValue: match.matchMode), mode != .bestOf1 {
                    Text(mode.rawValue)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(SquashGColors.neonCyan)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(
                            Capsule()
                                .fill(SquashGColors.neonCyan.opacity(0.15))
                        )
                }

                // Duration
                if match.duration > 0 {
                    HStack(spacing: 4) {
                        Image(systemName: "clock.fill")
                            .font(.system(size: 10))
                        Text(TimeInterval(match.duration).toDurationString())
                            .font(.system(size: 12, weight: .semibold))
                    }
                    .foregroundColor(.white.opacity(0.7))
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .background(Capsule().fill(Color.white.opacity(0.04)))
                }
            }

            HStack(spacing: 8) {
                // Player A
                VStack(alignment: .leading, spacing: 2) {
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

                    if match.eloChangeA != 0 {
                        Text(match.eloChangeA > 0 ? "+\(match.eloChangeA)" : "\(match.eloChangeA)")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(match.eloChangeA > 0 ? .green : .red.opacity(0.7))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                // Centered Score
                HStack(spacing: 8) {
                    Text("\(match.scoreA)")
                        .font(.system(size: 28, weight: .heavy))
                        .foregroundColor(isPlayerAWinner ? SquashGColors.neonCyan : .white.opacity(0.5))
                        .monospacedDigit()

                    Text("–")
                        .font(.system(size: 24, weight: .light))
                        .foregroundColor(.white.opacity(0.3))

                    Text("\(match.scoreB)")
                        .font(.system(size: 28, weight: .heavy))
                        .foregroundColor(isPlayerBWinner ? SquashGColors.neonCyan : .white.opacity(0.5))
                        .monospacedDigit()
                }
                .frame(minWidth: 100)

                // Player B
                VStack(alignment: .trailing, spacing: 2) {
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

                    if match.eloChangeB != 0 {
                        Text(match.eloChangeB > 0 ? "+\(match.eloChangeB)" : "\(match.eloChangeB)")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(match.eloChangeB > 0 ? .green : .red.opacity(0.7))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }

            // Set Scores (for multi-set matches)
            if !match.setScores.isEmpty {
                HStack(spacing: 6) {
                    ForEach(match.setScores) { setScore in
                        HStack(spacing: 3) {
                            Text("\(setScore.scoreA)")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(setScore.winner == "A" ? SquashGColors.neonCyan : .white.opacity(0.4))
                            Text("-")
                                .font(.system(size: 10, weight: .light))
                                .foregroundColor(.white.opacity(0.3))
                            Text("\(setScore.scoreB)")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(setScore.winner == "B" ? SquashGColors.neonCyan : .white.opacity(0.4))
                        }
                        .monospacedDigit()
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.white.opacity(0.03))
                        )
                    }
                }
            }

            if let notes = match.notes, !notes.isEmpty {
                Text(notes)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(.white.opacity(0.6))
                    .lineLimit(2)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .squashGCard()
    }
}

#Preview {
    HistoryView()
        .modelContainer(for: [Player.self, MatchRecord.self])
}
