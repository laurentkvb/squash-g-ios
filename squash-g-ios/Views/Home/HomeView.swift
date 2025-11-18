import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = HomeViewModel()
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
