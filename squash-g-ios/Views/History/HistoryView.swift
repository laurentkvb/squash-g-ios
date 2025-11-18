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
                    ScrollView(showsIndicators: true) {
                        LazyVStack(spacing: 10, pinnedViews: []) {
                            ForEach(matches) { match in
                                NavigationLink(destination: MatchDetailView(match: match)) {
                                    MatchRowView(match: match, highlightPlayer: nil)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .contextMenu {
                                    Button(role: .destructive) {
                                        pendingDeleteMatch = match
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }

                                    Button {
                                        selectedMatchForSheet = match
                                    } label: {
                                        Label("View", systemImage: "eye")
                                    }
                                }
                            }
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 20)
                    }
                    .ignoresSafeArea(edges: .bottom)
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
            .sheet(item: $selectedMatchForSheet) { match in
                MatchDetailView(match: match)
            }
        }
    }

    private func deleteMatch(_ match: MatchRecord) {
        Task { @MainActor in
            modelContext.delete(match)
            try? modelContext.save()
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
        VStack(alignment: .leading, spacing: 6) {
            // Date
            Text(match.date.formatted())
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.white.opacity(0.4))

            // Players and Score
            HStack(spacing: 12) {
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

                    // ELO Change
                    if match.eloChangeA != 0 {
                        Text(match.eloChangeA > 0 ? "+\(match.eloChangeA)" : "\(match.eloChangeA)")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(match.eloChangeA > 0 ? .green : .red.opacity(0.7))
                    }
                }

                Spacer()

                // Score
                HStack(spacing: 8) {
                    AdaptiveText(
                        text: "\(match.scoreA)",
                        maxFontSize: 32,
                        weight: .heavy,
                        textColor: UIColor(isPlayerAWinner ? SquashGColors.neonCyan : .white.opacity(0.5)),
                        minimumScaleFactor: 0.3,
                        isMonospacedDigits: true
                    )
                    .scaleEffect(0.75)

                    Text("–")
                        .font(.system(size: 24, weight: .light))
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                        .foregroundColor(.white.opacity(0.3))

                    AdaptiveText(
                        text: "\(match.scoreB)",
                        maxFontSize: 32,
                        weight: .heavy,
                        textColor: UIColor(isPlayerBWinner ? SquashGColors.neonCyan : .white.opacity(0.5)),
                        minimumScaleFactor: 0.3,
                        isMonospacedDigits: true
                    )
                    .scaleEffect(0.75)
                }

                Spacer()

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
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .squashGCard()
    }
}

#Preview {
    HistoryView()
        .modelContainer(for: [Player.self, MatchRecord.self])
}
