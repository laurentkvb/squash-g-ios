import SwiftUI
import SwiftData
import UIKit

// MARK: - PlayerPair Model
struct PlayerPair: Identifiable {
    let id = UUID()
    let playerA: Player
    let playerB: Player
    let count: Int
}

// MARK: - Suggested Pairs Computation
func computeSuggestedPairs(allPlayers: [Player], allMatches: [MatchRecord]) -> [PlayerPair] {
    // Generate all unique unordered pairs (A,B where A.id < B.id to avoid duplicates)
    var pairs: [String: (Player, Player, Int)] = [:]

    func keyFor(_ a: Player, _ b: Player) -> String {
        // stable key based on UUID strings in sorted order
        let aId = a.id.uuidString
        let bId = b.id.uuidString
        return aId < bId ? "\(aId)-\(bId)" : "\(bId)-\(aId)"
    }

    // initialize counts for every unique pair
    for i in 0..<allPlayers.count {
        for j in (i+1)..<allPlayers.count {
            let a = allPlayers[i]
            let b = allPlayers[j]
            let k = keyFor(a, b)
            pairs[k] = (a, b, 0)
        }
    }

    // Count matches for each pair (unordered)
    for match in allMatches {
        let a = match.playerA
        let b = match.playerB
        let k = keyFor(a, b)
        if var entry = pairs[k] {
            entry.2 += 1
            pairs[k] = entry
        } else {
            // If pair wasn't in the players list (e.g., players created after query), add it
            pairs[k] = (a, b, 1)
        }
    }

    // Map to PlayerPair and sort ascending by count (least played first)
    let mapped: [PlayerPair] = pairs.values.map { (a, b, count) in
        PlayerPair(playerA: a, playerB: b, count: count)
    }

    let sorted = mapped.sorted { lhs, rhs in
        if lhs.count == rhs.count {
            // stable fallback: sort alphabetically by playerA.name then playerB.name
            if lhs.playerA.name == rhs.playerA.name {
                return lhs.playerB.name < rhs.playerB.name
            }
            return lhs.playerA.name < rhs.playerA.name
        }
        return lhs.count < rhs.count
    }

    // Prefer unseen pairs (count == 0). Return up to 3 pairs.
    let unseen = sorted.filter { $0.count == 0 }
    if unseen.count >= 3 {
        return Array(unseen.prefix(3))
    }

    // If fewer than 3 unseen pairs, fill with the next least-played pairs
    var result: [PlayerPair] = unseen
    for p in sorted where result.count < 3 {
        if !result.contains(where: { $0.playerA.id == p.playerA.id && $0.playerB.id == p.playerB.id }) {
            result.append(p)
        }
    }

    return result
}

// MARK: - Pressable Button Style (subtle scale on press)
struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.985 : 1.0)
            .opacity(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

// MARK: - SuggestedPairRow View (styled to match PlayerCard)
struct SuggestedPairRow: View {
    let pair: PlayerPair
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                // Left group: avatar + name A
                HStack(spacing: 12) {
                    if let data = pair.playerA.avatarData, let ui = UIImage(data: data) {
                        Image(uiImage: ui)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(SquashGColors.neonCyan.opacity(0.25), lineWidth: 1)
                            )
                    } else {
                        ZStack {
                            Circle()
                                .fill(SquashGColors.backgroundDarker.opacity(0.5))
                                .frame(width: 50, height: 50)

                            Image(systemName: "person.fill")
                                .font(.system(size: 22))
                                .foregroundColor(SquashGColors.neonTeal)
                        }
                        .overlay(
                            Circle()
                                .stroke(SquashGColors.neonCyan.opacity(0.25), lineWidth: 1)
                        )
                    }

                    Text(pair.playerA.name)
                        .foregroundColor(SquashGColors.textPrimary)
                        .font(.system(size: 16, weight: .semibold))
                }

                Spacer()

                // Right group: name B + avatar
                HStack(spacing: 12) {
                    Text(pair.playerB.name)
                        .foregroundColor(SquashGColors.textPrimary)
                        .font(.system(size: 16, weight: .semibold))

                    if let dataB = pair.playerB.avatarData, let uiB = UIImage(data: dataB) {
                        Image(uiImage: uiB)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(SquashGColors.neonCyan.opacity(0.25), lineWidth: 1)
                            )
                    } else {
                        ZStack {
                            Circle()
                                .fill(SquashGColors.backgroundDarker.opacity(0.5))
                                .frame(width: 50, height: 50)

                            Image(systemName: "person.fill")
                                .font(.system(size: 22))
                                .foregroundColor(SquashGColors.neonTeal)
                        }
                        .overlay(
                            Circle()
                                .stroke(SquashGColors.neonCyan.opacity(0.25), lineWidth: 1)
                        )
                    }
                }
            }
            .padding(18)
            .squashGCard()
        }
        .buttonStyle(PressableButtonStyle())
    }
}

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = HomeViewModel()
    @Query private var players: [Player]
    @Query(sort: \MatchRecord.date, order: .reverse) private var matches: [MatchRecord]
    @State private var showScoreboard = false
    @State private var showPlayerSelector = false
    @State private var selectingPlayerSlot: String = "A" // "A" or "B"
    @State private var showSettings = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                SquashGColors.appBackgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        if viewModel.hasActiveMatch, let match = viewModel.activeMatch {
                            // Active Match State
                            ActiveMatchCard(match: match) {
                                showScoreboard = true
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                            .transition(.scale.combined(with: .opacity))
                        } else {
                            // No Active Match State
                            VStack(spacing: 20) {
                                // Player A
                                PlayerCard(title: "Player A", player: viewModel.selectedPlayerA) {
                                    selectingPlayerSlot = "A"
                                    showPlayerSelector = true
                                }
                                
                                // Player B
                                PlayerCard(title: "Player B", player: viewModel.selectedPlayerB) {
                                    selectingPlayerSlot = "B"
                                    showPlayerSelector = true
                                }

                                // Suggested Pairs
                                let suggestedPairs = computeSuggestedPairs(allPlayers: players, allMatches: matches)

                                if !suggestedPairs.isEmpty {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Suggested Pairs")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                            .padding(.leading, 4)

                                        ForEach(suggestedPairs) { pair in
                                            SuggestedPairRow(pair: pair) {
                                                withAnimation(.spring(response: 0.38, dampingFraction: 0.8)) {
                                                    viewModel.selectedPlayerA = pair.playerA
                                                    viewModel.selectedPlayerB = pair.playerB
                                                }
                                                HapticService.shared.selection()
                                            }
                                            .frame(maxWidth: .infinity)
                                        }
                                    }
                                    .padding(.top, 10)
                                }

                                // Match Settings
                                SettingsCard(
                                    targetScore: $viewModel.matchSettings.targetScore,
                                    winByTwo: $viewModel.matchSettings.winByTwo,
                                    tieBreakMode: $viewModel.matchSettings.tieBreakMode
                                )
                                
                                // Start Button
                                PrimaryButton(
                                    title: "Start Set",
                                    action: {
                                        viewModel.startMatch()
                                        showScoreboard = true
                                    },
                                    isEnabled: viewModel.canStartMatch
                                )
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                            .transition(.scale.combined(with: .opacity))
                        }
                    }
                    .padding(.bottom, 100)
                }
            }
            .centeredNavTitle("Play")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { showSettings = true }) {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white.opacity(0.85))
                    }
                }
            }
            .sheet(isPresented: $showPlayerSelector) {
                PlayerSelectorView(
                    selectedPlayer: Binding(
                        get: {
                            selectingPlayerSlot == "A" ? viewModel.selectedPlayerA : viewModel.selectedPlayerB
                        },
                        set: { newValue in
                            if selectingPlayerSlot == "A" {
                                viewModel.selectedPlayerA = newValue
                            } else {
                                viewModel.selectedPlayerB = newValue
                            }
                        }
                    ),
                    excludePlayerId: selectingPlayerSlot == "A" ? viewModel.selectedPlayerB?.id : viewModel.selectedPlayerA?.id
                )
            }
            .fullScreenCover(isPresented: $showScoreboard) {
                if let match = viewModel.activeMatch {
                    ScoreboardView(match: match)
                }
            }
            .onChange(of: viewModel.activeMatch != nil) { hasMatch in
                // If the active match disappears (cancelled or ended elsewhere), dismiss the scoreboard if it's open
                if !hasMatch {
                    showScoreboard = false
                }
            }
            .onAppear {
                viewModel.loadPlayersForActiveMatch(modelContext: modelContext)
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: [Player.self, MatchRecord.self])
}
