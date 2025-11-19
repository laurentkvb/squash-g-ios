import SwiftUI
import SwiftData

struct PlayersView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = PlayersViewModel()
    @Query(sort: \Player.eloRating, order: .reverse) private var players: [Player]
    @State private var showAddPlayer = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                SquashGColors.appBackgroundGradient
                    .ignoresSafeArea()
                
                if players.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "person.3.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.white.opacity(0.3))

                        Text("No players yet")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white.opacity(0.6))

                        Text("Add your first player to start tracking matches")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.white.opacity(0.4))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(players) { player in
                                NavigationLink(destination: PlayerDetailView(
                                    player: player,
                                    stats: viewModel.playerStats(for: player, modelContext: modelContext)
                                )) {
                                    PlayerRowView(
                                        player: player,
                                        stats: viewModel.playerStats(for: player, modelContext: modelContext)
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            .onDelete(perform: deletePlayers)
                        }
                        .padding(20)
                        .padding(.bottom, 100)
                    }
                }
                
                // Add Player moved to top-right toolbar
            }
            .centeredNavTitle("Players")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAddPlayer = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(SquashGColors.neonCyan)
                            .padding(8)
                    }
                }
            }
            .sheet(isPresented: $showAddPlayer) {
                AddPlayerView()
            }
        }
    }
    
    private func deletePlayers(at offsets: IndexSet) {
        for index in offsets {
            let player = players[index]
            modelContext.delete(player)
        }
        try? modelContext.save()
    }
}

struct PlayerRowView: View {
    let player: Player
    let stats: PlayerStats
    
    var body: some View {
        HStack(spacing: 16) {
            // Avatar
            if let avatarData = player.avatarData,
               let uiImage = UIImage(data: avatarData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(SquashGColors.neonCyan.opacity(0.5), lineWidth: 2)
                    )
            } else {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.05))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: "person.fill")
                        .font(.system(size: 26))
                        .foregroundColor(SquashGColors.neonCyan.opacity(0.7))
                }
                .overlay(
                    Circle()
                        .stroke(SquashGColors.neonCyan.opacity(0.25), lineWidth: 1)
                )
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(player.name)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                
                HStack(spacing: 12) {
                    HStack(spacing: 4) {
                        Text("ELO:")
                            .font(.system(size: 13, weight: .regular))
                            .foregroundColor(.white.opacity(0.6))
                        
                        Text("\(player.eloRating)")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(SquashGColors.neonCyan)
                    }
                    
                    if stats.matchesPlayed > 0 {
                        Text("•")
                            .foregroundColor(.white.opacity(0.3))
                        
                        Text("Win: \(String(format: "%.0f", stats.winRate))%")
                            .font(.system(size: 13, weight: .regular))
                            .foregroundColor(.white.opacity(0.6))
                    }
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(stats.wins)W")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.green)
                
                Text("\(stats.losses)L")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.red.opacity(0.7))
            }
            
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(SquashGColors.neonCyan.opacity(0.4))
        }
        .padding(16)
        .squashGCard()
    }
}

#Preview {
    PlayersView()
        .modelContainer(for: [Player.self, MatchRecord.self])
}
