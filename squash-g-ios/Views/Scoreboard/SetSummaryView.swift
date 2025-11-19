import SwiftUI

struct SetSummaryView: View {
    let setNumber: Int
    let winnerName: String
    let loserName: String
    let scoreA: Int
    let scoreB: Int
    let pointHistory: [ActiveMatch.PointState]
    let playerAName: String
    let playerBName: String
    let onContinue: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    @State private var showContent = false
    
    var winnerIsPlayerA: Bool {
        scoreA > scoreB
    }
    
    var body: some View {
        ZStack {
            SquashGColors.appBackgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header with Close Button
                HStack {
                    Spacer()
                    
                    Button(action: {
                        HapticService.shared.selection()
                        onContinue()
                    }) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(SquashGColors.neonCyan)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                .padding(.bottom, 8)
                
                ScrollView {
                    VStack(spacing: 28) {
                        // Trophy & Set Win Header
                        VStack(spacing: 16) {
                            Image(systemName: "trophy.fill")
                                .font(.system(size: 50))
                                .foregroundColor(SquashGColors.neonCyan)
                                .shadow(color: SquashGColors.neonCyan.opacity(0.6), radius: 20)
                                .scaleEffect(showContent ? 1.0 : 0.6)
                                .opacity(showContent ? 1 : 0)
                            
                            VStack(spacing: 8) {
                                Text("Set \(setNumber) Winner")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.white.opacity(0.7))
                                
                                Text(winnerName)
                                    .font(.system(size: 36, weight: .heavy))
                                    .foregroundColor(.white)
                            }
                            .opacity(showContent ? 1 : 0)
                        }
                        .padding(.top, 20)
                        
                        // Final Set Score
                        HStack(spacing: 20) {
                            VStack(spacing: 8) {
                                Text(playerAName)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.7))
                                
                                Text("\(scoreA)")
                                    .font(.system(size: 48, weight: .heavy))
                                    .foregroundColor(winnerIsPlayerA ? SquashGColors.neonCyan : .white.opacity(0.4))
                                    .monospacedDigit()
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
                                    .foregroundColor(!winnerIsPlayerA ? SquashGColors.neonCyan : .white.opacity(0.4))
                                    .monospacedDigit()
                            }
                        }
                        .padding(24)
                        .squashGCard()
                        .padding(.horizontal, 20)
                        .opacity(showContent ? 1 : 0)
                        
                        // Point-by-Point Progress
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Point-by-Point Progress")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                            
                            VStack(spacing: 12) {
                                if !pointHistory.isEmpty {
                                    LazyVGrid(columns: [
                                        GridItem(.flexible()),
                                        GridItem(.flexible()),
                                        GridItem(.flexible()),
                                        GridItem(.flexible())
                                    ], spacing: 10) {
                                        ForEach(Array(pointHistory.enumerated()), id: \.element.id) { index, point in
                                            VStack(spacing: 4) {
                                                HStack(spacing: 4) {
                                                    Text("\(point.scoreA)")
                                                        .font(.system(size: 14, weight: .bold))
                                                        .foregroundColor(.white.opacity(0.9))
                                                    Text("-")
                                                        .font(.system(size: 12, weight: .light))
                                                        .foregroundColor(.white.opacity(0.3))
                                                    Text("\(point.scoreB)")
                                                        .font(.system(size: 14, weight: .bold))
                                                        .foregroundColor(.white.opacity(0.9))
                                                }
                                                .monospacedDigit()
                                                
                                                // Point number indicator
                                                Text("#\(index)")
                                                    .font(.system(size: 10, weight: .medium))
                                                    .foregroundColor(.white.opacity(0.4))
                                            }
                                            .padding(.vertical, 10)
                                            .padding(.horizontal, 8)
                                            .frame(maxWidth: .infinity)
                                            .background(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .fill(
                                                        // Highlight final score
                                                        index == pointHistory.count - 1
                                                            ? SquashGColors.neonCyan.opacity(0.15)
                                                            : Color.white.opacity(0.04)
                                                    )
                                            )
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(
                                                        index == pointHistory.count - 1
                                                            ? SquashGColors.neonCyan.opacity(0.4)
                                                            : Color.clear,
                                                        lineWidth: 1.5
                                                    )
                                            )
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                } else {
                                    Text("No point history available")
                                        .font(.system(size: 14, weight: .regular))
                                        .foregroundColor(.white.opacity(0.5))
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 20)
                                }
                            }
                        }
                        .padding(.vertical, 20)
                        .squashGCard()
                        .padding(.horizontal, 20)
                        .opacity(showContent ? 1 : 0)
                        
                        // Continue Button
                        PrimaryButton(
                            title: "Continue",
                            action: {
                                HapticService.shared.medium()
                                onContinue()
                            },
                            isEnabled: true
                        )
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)
                        .opacity(showContent ? 1 : 0)
                    }
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.1)) {
                showContent = true
            }
            HapticService.shared.success()
        }
    }
}

#Preview {
    SetSummaryView(
        setNumber: 1,
        winnerName: "John Doe",
        loserName: "Jane Smith",
        scoreA: 11,
        scoreB: 7,
        pointHistory: [
            ActiveMatch.PointState(scoreA: 0, scoreB: 0),
            ActiveMatch.PointState(scoreA: 1, scoreB: 0),
            ActiveMatch.PointState(scoreA: 1, scoreB: 1),
            ActiveMatch.PointState(scoreA: 2, scoreB: 1),
            ActiveMatch.PointState(scoreA: 3, scoreB: 1),
            ActiveMatch.PointState(scoreA: 3, scoreB: 2),
            ActiveMatch.PointState(scoreA: 4, scoreB: 2),
            ActiveMatch.PointState(scoreA: 5, scoreB: 2),
            ActiveMatch.PointState(scoreA: 5, scoreB: 3),
            ActiveMatch.PointState(scoreA: 6, scoreB: 3),
            ActiveMatch.PointState(scoreA: 7, scoreB: 3),
            ActiveMatch.PointState(scoreA: 8, scoreB: 3),
            ActiveMatch.PointState(scoreA: 8, scoreB: 4),
            ActiveMatch.PointState(scoreA: 9, scoreB: 4),
            ActiveMatch.PointState(scoreA: 9, scoreB: 5),
            ActiveMatch.PointState(scoreA: 10, scoreB: 5),
            ActiveMatch.PointState(scoreA: 10, scoreB: 6),
            ActiveMatch.PointState(scoreA: 11, scoreB: 6),
            ActiveMatch.PointState(scoreA: 11, scoreB: 7)
        ],
        playerAName: "John Doe",
        playerBName: "Jane Smith",
        onContinue: {}
    )
}
