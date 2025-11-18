import SwiftUI
import SwiftData

struct PlayerSelectorView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Player.eloRating, order: .reverse) private var players: [Player]
    
    @Binding var selectedPlayer: Player?
    var excludePlayerId: UUID?
    
    @State private var showAddPlayer = false
    
    var filteredPlayers: [Player] {
        if let excludeId = excludePlayerId {
            return players.filter { $0.id != excludeId }
        }
        return players
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                SquashGColors.appBackgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(filteredPlayers) { player in
                            PlayerSelectRow(player: player, isSelected: selectedPlayer?.id == player.id) {
                                selectedPlayer = player
                                HapticService.shared.selection()
                                dismiss()
                            }
                        }
                        
                        // Add New Player Button
                        Button(action: {
                            showAddPlayer = true
                        }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 20))
                                
                                Text("Add New Player")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                            .foregroundColor(SquashGColors.neonCyan)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .squashGNeonButton(borderColor: SquashGColors.neonCyan)
                        }
                        .padding(.top, 8)
                    }
                    .padding(20)
                    .padding(.bottom, 100)
                }
            }
            .navigationTitle("Select Player")
            .navigationBarTitleDisplayMode(.inline)
            .centeredNavTitle("Select Player")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(SquashGColors.neonCyan)
                }
            }
            .sheet(isPresented: $showAddPlayer) {
                AddPlayerView()
            }
        }
    }
}

struct PlayerSelectRow: View {
    let player: Player
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Avatar
                if let avatarData = player.avatarData,
                   let uiImage = UIImage(data: avatarData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(isSelected ? SquashGColors.neonCyan : SquashGColors.neonCyan.opacity(0.3), lineWidth: 2)
                        )
                } else {
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.05))
                            .frame(width: 50, height: 50)
                        
                        Image(systemName: "person.fill")
                            .font(.system(size: 22))
                            .foregroundColor(SquashGColors.neonCyan.opacity(0.7))
                    }
                    .overlay(
                        Circle()
                            .stroke(isSelected ? SquashGColors.neonCyan : SquashGColors.neonCyan.opacity(0.25), lineWidth: 1)
                    )
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(player.name)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text("ELO: \(player.eloRating)")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.white.opacity(0.6))
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(SquashGColors.neonCyan)
                }
            }
            .padding(16)
            .squashGCard()
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    PlayerSelectorView(selectedPlayer: .constant(nil), excludePlayerId: nil)
        .modelContainer(for: [Player.self, MatchRecord.self])
}
