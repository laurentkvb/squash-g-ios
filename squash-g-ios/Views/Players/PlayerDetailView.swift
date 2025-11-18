import SwiftUI
import SwiftData

struct PlayerDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: PlayerDetailViewModel
    @State private var showHistory = false
    
    init(player: Player, stats: PlayerStats) {
        _viewModel = StateObject(wrappedValue: PlayerDetailViewModel(player: player, stats: stats))
    }
    
    var body: some View {
        ZStack {
            SquashGColors.appBackgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Player Header
                    VStack(spacing: 16) {
                        // Avatar
                        if let avatarData = viewModel.player.avatarData,
                           let uiImage = UIImage(data: avatarData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 120, height: 120)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle()
                                            .stroke(SquashGColors.neonCyan, lineWidth: 3)
                                    )
                                    .shadow(color: SquashGColors.neonCyan.opacity(0.5), radius: 20)
                        } else {
                            ZStack {
                                Circle()
                                    .fill(SquashGColors.backgroundDarker.opacity(0.5))
                                    .frame(width: 120, height: 120)

                                Image(systemName: "person.fill")
                                    .font(.system(size: 56))
                                    .foregroundColor(SquashGColors.neonTeal)
                            }
                            .overlay(
                                Circle()
                                    .stroke(SquashGColors.neonCyan, lineWidth: 2)
                            )
                            .shadow(color: SquashGColors.neonCyan.opacity(0.3), radius: 16)
                        }
                        
                        Text(viewModel.player.name)
                            .font(.system(size: 32, weight: .heavy))
                            .foregroundColor(.white)
                    }
                    .padding(.top, 20)
                    
                    // ELO Rating Card
                    VStack(spacing: 12) {
                        Text("ELO Rating")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.5))
                        
                        Text("\(viewModel.player.eloRating)")
                            .font(.system(size: 56, weight: .heavy))
                            .foregroundColor(SquashGColors.neonCyan)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 24)
                        .squashGCard()
                    
                    // Stats Grid
                    VStack(spacing: 16) {
                        HStack(spacing: 16) {
                                StatCard(
                                title: "Matches",
                                value: "\(viewModel.stats.matchesPlayed)",
                                color: SquashGColors.neonTeal
                            )
                            
                            StatCard(
                                title: "Wins",
                                value: "\(viewModel.stats.wins)",
                                color: SquashGColors.neonCyan
                            )
                        }
                        
                        HStack(spacing: 16) {
                            StatCard(
                                title: "Losses",
                                value: "\(viewModel.stats.losses)",
                                color: SquashGColors.neonPink.opacity(0.9)
                            )
                            
                            StatCard(
                                title: "Win Rate",
                                value: String(format: "%.0f%%", viewModel.stats.winRate),
                                color: SquashGColors.neonCyan
                            )
                        }
                    }
                    
                    // Match History Button
                    Button(action: {
                        showHistory = true
                    }) {
                        Text("View Match History")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(SquashGColors.neonTeal)
                            .frame(maxWidth: .infinity)
                    }
                    .squashGNeonButton(borderColor: SquashGColors.neonTeal)
                }
                .padding(20)
                .padding(.bottom, 100)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showHistory) {
            PlayerMatchHistoryView(player: viewModel.player)
        }
        .onAppear {
            viewModel.refreshStats(modelContext: modelContext)
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.white.opacity(0.5))
            
            Text(value)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
            .squashGCard()
    }
}

#Preview {
    NavigationStack {
        PlayerDetailView(
            player: Player(name: "John Doe", eloRating: 1450),
            stats: PlayerStats(matchesPlayed: 20, wins: 12, losses: 8, winRate: 60)
        )
    }
    .modelContainer(for: [Player.self, MatchRecord.self])
}
