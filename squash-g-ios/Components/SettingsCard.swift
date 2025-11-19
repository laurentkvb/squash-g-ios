import SwiftUI

struct SettingsCard: View {
    @Binding var matchMode: MatchMode
    @Binding var targetScore: Int
    @Binding var winByTwo: Bool
    @Binding var tieBreakMode: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("Match Settings")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.white.opacity(0.5))
            
            // Match Mode
            VStack(alignment: .leading, spacing: 10) {
                Text("Match Mode")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.white)
                
                HStack(spacing: 8) {
                    ForEach(MatchMode.allCases, id: \.self) { mode in
                        Button(action: {
                            matchMode = mode
                            HapticService.shared.selection()
                        }) {
                            Text(mode.rawValue)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(matchMode == mode ? .black : .white)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 12)
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(matchMode == mode ? SquashGColors.neonCyan : Color.white.opacity(0.05))
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(matchMode == mode ? Color.clear : SquashGColors.neonCyan.opacity(0.2), lineWidth: 1)
                                )
                        }
                    }
                }
            }
            
            Divider()
                .background(Color.white.opacity(0.06))
            
            // Target Score
            HStack {
                Text("Target Score")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.white)
                
                Spacer()
                
                HStack(spacing: 12) {
                    Button(action: {
                        if targetScore > 1 {
                            targetScore -= 1
                            HapticService.shared.selection()
                        }
                    }) {
                        Image(systemName: "minus")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(SquashGColors.neonTeal)
                            .frame(width: 36, height: 36)
                            .background(Circle().fill(Color.black.opacity(0.15)))
                    }

                    Text("\(targetScore)")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(SquashGColors.neonTeal)
                        .frame(width: 40)

                    Button(action: {
                        targetScore += 1
                        HapticService.shared.selection()
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(SquashGColors.neonTeal)
                            .frame(width: 36, height: 36)
                            .background(Circle().fill(Color.black.opacity(0.15)))
                    }
                }
            }
            
            Divider()
                .background(Color.white.opacity(0.06))
            
            // Win by Two
            Toggle(isOn: $winByTwo) {
                Text("Win by Two")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.white)
                Text("Atleast 2 points difference is needed to win")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.white.opacity(0.5))
            }
            .tint(SquashGColors.neonTeal)
            .onChange(of: winByTwo) { _, _ in
                HapticService.shared.selection()
            }
            
            Divider()
                .background(Color.white.opacity(0.06))
            
            // Tie-break Mode
            Toggle(isOn: $tieBreakMode) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Tie-break Mode")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.white)
                    
                    Text("Play to 15 points")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.white.opacity(0.5))
                }
            }
            .tint(SquashGColors.neonTeal)
            .onChange(of: tieBreakMode) { _, _ in
                HapticService.shared.selection()
            }
        }
        .padding(18)
        .squashGCard()
    }
}

#Preview {
    SettingsCard(
        matchMode: .constant(.bestOf1),
        targetScore: .constant(11),
        winByTwo: .constant(true),
        tieBreakMode: .constant(false)
    )
    .padding()
    .background(SquashGColors.appBackgroundGradient)
}
