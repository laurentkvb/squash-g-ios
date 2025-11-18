import SwiftUI

struct OnboardingPageView: View {
    let model: OnboardingPageModel
    var body: some View {
        ZStack {
            // Card with glow
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(SquashGColors.cardDark)
                .frame(maxWidth: .infinity)
                .shadow(color: model.backgroundGlow.opacity(0.16), radius: 30, x: 0, y: 12)

            VStack(spacing: 18) {
                // Icon
                model.icon
                    .frame(width: 140, height: 140)
                    .background(
                        Circle()
                            .fill(model.backgroundGlow.opacity(0.08))
                            .blur(radius: 10)
                    )
                    .clipShape(Circle())

                // Title
                Text(model.title)
                    .font(.system(size: 22, weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(SquashGColors.textPrimary)
                    .padding(.horizontal, 20)

                // Subtitle
                Text(model.subtitle)
                    .font(.system(size: 15, weight: .regular))
                    .multilineTextAlignment(.center)
                    .foregroundColor(SquashGColors.textSecondary)
                    .padding(.horizontal, 26)

                Spacer(minLength: 6)
            }
            .padding(28)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 24)
    }
}

#Preview {
    OnboardingPageView(model: OnboardingPageModel(title: "Track your squash games effortlessly", subtitle: "SquashG keeps score using simple game sets. Just tap to add points — we handle the rest.", icon: AnyView(Image(systemName: "sportscourt.fill").resizable().scaledToFit().foregroundColor(SquashGColors.neonPink)), backgroundGlow: SquashGColors.neonPink))
        .background(SquashGColors.appBackgroundGradient.ignoresSafeArea())
}
