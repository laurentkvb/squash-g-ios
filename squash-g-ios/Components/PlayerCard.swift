import SwiftUI

struct PlayerCard: View {
    let title: String
    let player: Player?
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            HapticService.shared.selection()
            action()
        }) {
            HStack(spacing: 16) {
                // Avatar
                    if let avatarData = player?.avatarData,
                       let uiImage = UIImage(data: avatarData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(SquashGColors.neonCyan.opacity(0.5), lineWidth: 1)
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
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(SquashGColors.textSecondary)

                    Text(player?.name ?? "Select Player")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(SquashGColors.textPrimary)
                }
                
                Spacer()
                
                if let player = player {
                    Text("\(player.eloRating)")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(SquashGColors.neonCyan)
                }

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(SquashGColors.neonCyan)
            }
            .padding(18)
            .squashGCard()
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    VStack(spacing: 16) {
        PlayerCard(title: "Player A", player: nil) {
            print("Select Player A")
        }
        
        PlayerCard(title: "Player B", player: Player(name: "John Doe", eloRating: 1450)) {
            print("Select Player B")
        }
    }
    .padding()
    .background(SquashGColors.appBackgroundGradient)
}
