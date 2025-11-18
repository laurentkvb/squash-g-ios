
import SwiftUI
import SwiftData

struct MainTabView: View {
    @AppStorage("selectedTabIndex") private var selectedTab = 0

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
    }
}

#Preview {
    MainTabView()
        .modelContainer(for: [Player.self, MatchRecord.self])
}
