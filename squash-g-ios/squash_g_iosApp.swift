//
//  squash_g_iosApp.swift
//  squash-g-ios
//
//  Created by Laurent Kleering van Beerenbergh on 17/11/2025.
//

import SwiftUI
import SwiftData

@main
struct squash_g_iosApp: App {
    @State private var showMain = false
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Player.self,
            MatchRecord.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if showMain {
                    // Always show the main tab view. MainTabView is responsible for
                    // presenting onboarding when appropriate (initial run or explicit request).
                    MainTabView()
                        .modelContainer(sharedModelContainer)
                        .transition(.opacity)
                } else {
                    SplashScreenView(showMain: $showMain)
                        .transition(.opacity)
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}
