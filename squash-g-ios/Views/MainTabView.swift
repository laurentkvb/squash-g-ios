
import SwiftUI
import SwiftData

struct MainTabView: View {
    @AppStorage("selectedTabIndex") private var selectedTab = 0
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
    @AppStorage("presentOnboardingNow") private var presentOnboardingNow: Bool = false
    
    private var shouldShowOnboarding: Bool {
        !hasSeenOnboarding || presentOnboardingNow
    }
    
    private func completeOnboarding() {
        hasSeenOnboarding = true
        presentOnboardingNow = false
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Play", systemImage: "house.fill")
                }
                .tag(0)

            HistoryView()
                .tabItem {
                    Label("History", systemImage: "clock.arrow.circlepath")
                }
                .tag(1)

            PlayersView()
                .tabItem {
                    Label("Players", systemImage: "person.2.fill")
                }
                .tag(2)
        }
        .background(SquashGColors.appBackgroundGradient.ignoresSafeArea())
        .tint(SquashGColors.neonCyan)
        .onChange(of: shouldShowOnboarding) { newValue in
            if newValue {
                // Trigger presentation when needed
            }
        }
        .fullScreenCover(isPresented: Binding(
            get: { shouldShowOnboarding },
            set: { if !$0 { completeOnboarding() } }
        )) {
            OnboardingContainerView(onComplete: completeOnboarding)
        }
    }
}

#Preview {
    MainTabView()
        .modelContainer(for: [Player.self, MatchRecord.self])
}
