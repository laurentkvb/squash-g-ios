import SwiftUI
import SwiftData

struct OnboardingContainerView: View {
    @Environment(\.dismiss) private var dismiss
    
    /// Callback invoked when the user completes onboarding
    var onComplete: (() -> Void)?
    
    @State private var selection: Int = 0

    private var pages: [OnboardingPageModel] {
        [
            OnboardingPageModel(
                title: "Track your squash games effortlessly",
                subtitle: "SquashG keeps score using simple game sets. Just tap to add points — we handle the rest.",
                icon: AnyView(RacketIcon().padding()),
                backgroundGlow: SquashGColors.neonPink
            ),
            OnboardingPageModel(
                title: "Perfect for playing with friends",
                subtitle: "Everything runs locally on your device. No accounts, no cloud — just quick and fun scoring.",
                icon: AnyView(GroupIcon().padding()),
                backgroundGlow: SquashGColors.neonCyan
            ),
            OnboardingPageModel(
                title: "Your players and match history",
                subtitle: "Create players, track sets, and view your history — including ELO, wins, and streaks.",
                icon: AnyView(HStack(spacing:12){ PlayerIcon().frame(width:44,height:44); TrophyIcon().frame(width:44,height:44); HistoryIcon().frame(width:44,height:44)}),
                backgroundGlow: SquashGColors.neonTeal
            )
        ]
    }

    var body: some View {
        ZStack {
            SquashGColors.appBackgroundGradient.ignoresSafeArea()

            VStack(spacing: 0) {
                // Top bar with skip button (jumps to last page)
                HStack {
                    Spacer()
                    if selection < pages.count - 1 {
                        Button(action: {
                            withAnimation(.spring()) {
                                selection = pages.count - 1
                            }
                        }) {
                            Text("Skip")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(SquashGColors.neonCyan)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(SquashGColors.neonCyan.opacity(0.1))
                                )
                        }
                        .padding(.trailing, 20)
                        .padding(.top, 16)
                    }
                }
                .frame(height: 60)
                
                TabView(selection: $selection) {
                    ForEach(0..<pages.count, id: \.self) { idx in
                        let page = pages[idx]
                        VStack {
                            Spacer()
                            OnboardingPageView(model: page)
                                .frame(maxHeight: 520)
                            Spacer()
                            // Dots + Next / CTA
                            VStack(spacing: 16) {
                                HStack(spacing: 8) {
                                    ForEach(0..<pages.count, id: \.self) { i in
                                        Circle()
                                            .fill(i == selection ? SquashGColors.neonCyan : Color.gray.opacity(0.25))
                                            .frame(width: i == selection ? 12 : 8, height: i == selection ? 12 : 8)
                                            .scaleEffect(i == selection ? 1.05 : 1.0)
                                            .animation(.easeInOut(duration: 0.18), value: selection)
                                    }
                                }

                                if selection < pages.count - 1 {
                                    HStack {
                                        OnboardingButton(title: "Next") {
                                            withAnimation(.spring()) {
                                                selection += 1
                                            }
                                        }
                                    }
                                } else {
                                    VStack(spacing:8) {
                                        OnboardingButton(title: "Start Using SquashG", action: {
                                            onComplete?()
                                            dismiss()
                                        }, isPrimary: true)

                                        Text("Let’s play.")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(SquashGColors.textSecondary)
                                    }
                                }
                            }
                            .padding(.bottom, 26)
                        }
                        .tag(idx)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: selection)
            }
        }
    }
}

// MARK: - Small neon icon views

private struct RacketIcon: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(SquashGColors.neonPink.opacity(0.12))
                .frame(width: 140, height: 140)
                .shadow(color: SquashGColors.neonPink.opacity(0.25), radius: 20)

            // Racket body
            Capsule()
                .fill(LinearGradient(colors: [SquashGColors.neonPink, SquashGColors.neonCyan], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 18, height: 90)
                .rotationEffect(.degrees(-30))
                .offset(x: -12, y: -8)

            // Ball
            Circle()
                .fill(SquashGColors.neonPink)
                .frame(width: 24, height: 24)
                .offset(x: 28, y: -20)
                .shadow(color: SquashGColors.neonPink.opacity(0.6), radius: 8)
        }
    }
}

private struct GroupIcon: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(SquashGColors.neonCyan.opacity(0.08))
                .frame(width: 120, height: 120)
                .shadow(color: SquashGColors.neonCyan.opacity(0.2), radius: 16)

            Image(systemName: "person.3.fill")
                .resizable()
                .scaledToFit()
                .foregroundColor(SquashGColors.neonCyan)
                .padding(22)
        }
    }
}

private struct PlayerIcon: View {
    var body: some View {
        Image(systemName: "person.fill")
            .resizable()
            .scaledToFit()
            .foregroundColor(SquashGColors.neonCyan)
    }
}

private struct TrophyIcon: View {
    var body: some View {
        Image(systemName: "rosette")
            .resizable()
            .scaledToFit()
            .foregroundColor(SquashGColors.neonPink)
            .shadow(color: SquashGColors.neonPink.opacity(0.3), radius: 8)
    }
}

private struct HistoryIcon: View {
    var body: some View {
        Image(systemName: "clock.arrow.circlepath")
            .resizable()
            .scaledToFit()
            .foregroundColor(SquashGColors.neonTeal)
    }
}

#Preview {
    OnboardingContainerView()
}
