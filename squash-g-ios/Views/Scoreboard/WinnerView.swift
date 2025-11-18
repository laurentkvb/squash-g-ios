import SwiftUI

struct WinnerView: View {
    let winnerName: String
    let scoreA: Int
    let scoreB: Int
    let playerAName: String
    let playerBName: String
    let eloChangeA: Int
    let eloChangeB: Int
    let onDone: () -> Void
    let onRematch: () -> Void
    
    @State private var showContent = false
    
    var body: some View {
        ZStack {
            SquashGColors.appBackgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                Spacer()
                
                // Trophy Icon
                Image(systemName: "trophy.fill")
                    .font(.system(size: 80))
                    .foregroundColor(SquashGColors.neonCyan)
                    .shadow(color: SquashGColors.neonCyan.opacity(0.8), radius: 30)
                    .scaleEffect(showContent ? 1.0 : 0.5)
                    .opacity(showContent ? 1 : 0)
                
                // Winner Name
                VStack(spacing: 8) {
                    Text("Winner!")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                    
                    Text(winnerName)
                        .font(.system(size: 42, weight: .heavy))
                        .foregroundColor(.white)
                }
                .opacity(showContent ? 1 : 0)
                
                // Score
                HStack(spacing: 20) {
                    VStack(spacing: 8) {
                        Text(playerAName)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white.opacity(0.7))
                        
                        Text("\(scoreA)")
                            .font(.system(size: 48, weight: .heavy))
                            .foregroundColor(SquashGColors.neonCyan)
                    }
                    
                    Text("–")
                        .font(.system(size: 32, weight: .light))
                        .foregroundColor(.white.opacity(0.3))
                    
                    VStack(spacing: 8) {
                        Text(playerBName)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white.opacity(0.7))
                        
                        Text("\(scoreB)")
                            .font(.system(size: 48, weight: .heavy))
                            .foregroundColor(SquashGColors.neonCyan)
                    }
                }
                .padding(24)
                .squashGCard()
                .opacity(showContent ? 1 : 0)
                
                // ELO Changes
                VStack(spacing: 16) {
                    Text("ELO Rating Changes")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.6))
                    
                    HStack(spacing: 32) {
                        VStack(spacing: 4) {
                            Text(playerAName)
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(.white.opacity(0.7))
                            
                            Text(eloChangeA >= 0 ? "+\(eloChangeA)" : "\(eloChangeA)")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(eloChangeA >= 0 ? SquashGColors.goldAccent : SquashGColors.neonPink)
                        }
                        
                        VStack(spacing: 4) {
                            Text(playerBName)
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(.white.opacity(0.7))
                            
                            Text(eloChangeB >= 0 ? "+\(eloChangeB)" : "\(eloChangeB)")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(eloChangeB >= 0 ? SquashGColors.goldAccent : SquashGColors.neonPink)
                        }
                    }
                }
                .padding(20)
                .squashGCard(glowColor: SquashGColors.neonTeal)
                .opacity(showContent ? 1 : 0)
                
                Spacer()
                
                // Buttons
                VStack(spacing: 16) {
                    NeonButton(
                        title: "Rematch",
                        borderColor: SquashGColors.neonCyan,
                        action: onRematch
                    )
                    
                    Button(action: onDone) {
                        Text("Done")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white.opacity(0.7))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                    }
                }
                .padding(.horizontal, 20)
                .opacity(showContent ? 1 : 0)
            }
            .padding(.vertical, 40)
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.2)) {
                showContent = true
            }
        }
    }
}

#Preview {
    WinnerView(
        winnerName: "John Doe",
        scoreA: 11,
        scoreB: 9,
        playerAName: "John Doe",
        playerBName: "Jane Smith",
        eloChangeA: 24,
        eloChangeB: -24,
        onDone: {},
        onRematch: {}
    )
}
