import SwiftUI

struct ActiveMatchCard: View {
    let match: ActiveMatch
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            HapticService.shared.medium()
            action()
        }) {
            VStack(spacing: 18) {
                // Title
                Text("Active Match")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.white.opacity(0.5))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // Players and Score
                HStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(match.playerAName)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                        
                        AdaptiveText(
                            text: "\(match.scoreA)",
                            maxFontSize: 36,
                            weight: .heavy,
                            textColor: UIColor(SquashGColors.neonCyan),
                            minimumScaleFactor: 0.3,
                            isMonospacedDigits: true
                        )
                    }
                    
                    Spacer()
                    
                    Text("–")
                        .font(.system(size: 32, weight: .light))
                        .foregroundColor(.white.opacity(0.3))
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 8) {
                        Text(match.playerBName)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                        
                        AdaptiveText(
                            text: "\(match.scoreB)",
                            maxFontSize: 36,
                            weight: .heavy,
                            textColor: UIColor(SquashGColors.neonCyan),
                            minimumScaleFactor: 0.3,
                            isMonospacedDigits: true
                        )
                    }
                }
                
                // Elapsed Time
                HStack {
                    Image(systemName: "clock.fill")
                        .font(.system(size: 12))
                    
                    Text(Date().elapsedTime(from: match.startDate))
                        .font(.system(size: 14, weight: .medium))
                }
                .foregroundColor(.white.opacity(0.6))
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Divider()
                    .background(Color.white.opacity(0.06))
                
                // Continue Button
                HStack {
                    Text("Continue Match")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(SquashGColors.neonCyan)
                    
                    Spacer()
                    
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(SquashGColors.neonCyan)
                }
            }
            .padding(18)
            .squashGCard()
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ActiveMatchCard(
        match: ActiveMatch(
            playerAId: UUID(),
            playerBId: UUID(),
            playerAName: "John Doe",
            playerBName: "Jane Smith",
            scoreA: 7,
            scoreB: 6,
            startDate: Date().addingTimeInterval(-300),
            settings: MatchSettings(),
            scoreHistory: []
        )
    ) {
        print("Continue Match")
    }
    .padding()
    .background(SquashGColors.appBackgroundGradient)
}
