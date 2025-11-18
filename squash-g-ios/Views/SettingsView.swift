import SwiftUI
import SwiftData

// Notification names for app-wide events
extension Notification.Name {
    static let didClearLocalData = Notification.Name("didClearLocalData")
}

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @AppStorage("presentOnboardingNow") private var presentOnboardingNow: Bool = false
    @State private var showClearAlert = false
    @State private var showOnboardingNow = false
    var body: some View {
        NavigationStack {
            ZStack {
                SquashGColors.appBackgroundGradient
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        // Data Card
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 12) {
                                Image(systemName: "tray.full")
                                    .foregroundColor(SquashGColors.goldAccent)
                                    .font(.system(size: 20))
                                Text("Data")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }

                            Divider().background(Color.white.opacity(0.06))

                            VStack(spacing: 12) {
                                Button(action: { showClearAlert = true }) {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text("Clear Local Data")
                                                .foregroundColor(.white)
                                                .font(.system(size: 16, weight: .semibold))
                                            Text("Remove all players and match history from this device.")
                                                .foregroundColor(SquashGColors.textSecondary)
                                                .font(.system(size: 13))
                                                .multilineTextAlignment(.leading)
                                        }
                                        Spacer()
                                        Image(systemName: "trash.fill")
                                            .foregroundColor(.red)
                                    }
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius: 16).fill(Color.black.opacity(0.12)))
                                }
                                .alert("Clear all local players and history?", isPresented: $showClearAlert) {
                                    Button("Clear", role: .destructive) {
                                        clearLocalData()
                                        // Show onboarding immediately after clearing — present from app root
                                        presentOnboardingNow = true
                                        // Dismiss this settings sheet immediately to avoid flicker
                                        dismiss()
                                    }
                                    Button("Cancel", role: .cancel) {}
                                } message: {
                                    Text("This will remove all players and match history from this device. It cannot be undone.")
                                }
                            }
                        }
                        .padding()
                        .squashGCard(glowColor: SquashGColors.goldAccent)
                        .padding(.horizontal, 20)

                        Spacer()
                    }
                    .padding(.top, 30)
                    .padding(.bottom, 40)
                }
            }
            .centeredNavTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showOnboardingNow = true
                    }) {
                        Image(systemName: "info.circle.fill")
                            .foregroundColor(SquashGColors.neonCyan)
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        .fullScreenCover(isPresented: $showOnboardingNow) {
            OnboardingContainerView()
        }
        }
    }

    private func clearLocalData() {
        Task { @MainActor in
            let fetchPlayers = FetchDescriptor<Player>()
            let fetchMatches = FetchDescriptor<MatchRecord>()
            if let players = try? modelContext.fetch(fetchPlayers) {
                for p in players { modelContext.delete(p) }
            }
            if let matches = try? modelContext.fetch(fetchMatches) {
                for m in matches { modelContext.delete(m) }
            }
            try? modelContext.save()
            // Notify the app that local data was cleared so in-memory state can reset
            NotificationCenter.default.post(name: .didClearLocalData, object: nil)
            // Also clear any persisted active match state
            ActiveMatchService.shared.endMatch()
        }
    }
}

#Preview {
    SettingsView()
        .modelContainer(for: [Player.self, MatchRecord.self])
}
