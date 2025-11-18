import SwiftUI

struct OnboardingButton: View {
    let title: String
    let action: () -> Void
    var isPrimary: Bool = false

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 18, weight: .semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
        }
        .buttonStyle(PlainButtonStyle())
        .background(
            Group {
                if isPrimary {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(SquashGColors.neonPink.opacity(0.15))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .stroke(LinearGradient(colors: [SquashGColors.neonPink, SquashGColors.neonCyan], startPoint: .leading, endPoint: .trailing), lineWidth: 2)
                        )
                        .shadow(color: SquashGColors.neonPink.opacity(0.35), radius: 14, x: 0, y: 8)
                } else {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(Color.black.opacity(0.18))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .stroke(SquashGColors.neonPink.opacity(0.18), lineWidth: 1)
                        )
                }
            }
        )
        .foregroundColor(isPrimary ? SquashGColors.neonPink : Color.white)
        .padding(.horizontal, 24)
    }
}

#Preview {
    VStack(spacing:12) {
        OnboardingButton(title: "Next", action: {}, isPrimary: false)
        OnboardingButton(title: "Start Using SquashG", action: {}, isPrimary: true)
    }
    .padding()
    .background(SquashGColors.appBackgroundGradient.ignoresSafeArea())
}
