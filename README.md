# SquashG - iOS Squash Score Tracking App

A modern, slick iOS app built with SwiftUI for tracking squash matches with ELO ratings and Live Activities support.

## Features

- **Match Tracking**: Start and track live squash matches with real-time scoring
- **ELO Rating System**: Automatic ELO calculation and player ranking
- **Live Activities**: Track ongoing matches from Lock Screen and Dynamic Island (iOS 16.1+)
- **Player Management**: Add, manage, and view detailed player statistics
- **Match History**: Complete history with detailed stats and ELO changes
- **Manual Entry**: Add historical matches manually
- **Dark Neon UI**: Premium sporty design with neon accents and glass morphism

## Technology Stack

- **SwiftUI**: Modern declarative UI framework
- **MVVM Architecture**: Clean separation of concerns
- **SwiftData**: Persistent data storage
- **ActivityKit**: Live Activities support
- **Swift Concurrency**: Async/await patterns

## Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

## Project Structure

```
squash-g-ios/
├── Models/               # SwiftData models
│   ├── Player.swift
│   ├── MatchRecord.swift
│   ├── MatchSettings.swift
│   └── ActiveMatch.swift
├── ViewModels/          # MVVM ViewModels
│   ├── HomeViewModel.swift
│   ├── ScoreboardViewModel.swift
│   ├── PlayersViewModel.swift
│   ├── PlayerDetailViewModel.swift
│   ├── AddPlayerViewModel.swift
│   └── ManualSetViewModel.swift
├── Views/               # SwiftUI Views
│   ├── Splash/
│   ├── Home/
│   ├── Scoreboard/
│   ├── Players/
│   ├── History/
│   └── MainTabView.swift
├── Components/          # Reusable UI components
│   ├── NeonButton.swift
│   ├── PlayerCard.swift
│   ├── SettingsCard.swift
│   ├── ActiveMatchCard.swift
│   └── ConfettiView.swift
├── Services/            # Business logic services
│   ├── ELOService.swift
│   ├── HapticService.swift
│   ├── TimerService.swift
│   └── ActiveMatchService.swift
├── LiveActivities/      # Live Activity implementation
│   ├── MatchActivityAttributes.swift
│   ├── LiveActivityService.swift
│   └── MatchActivityWidget.swift
├── Theme/               # App theming
│   └── Theme.swift
└── Extensions/          # Swift extensions
    ├── Date+Extensions.swift
    └── View+Extensions.swift
```

## Setup Instructions

### 1. Add Files to Xcode Project

After cloning, you need to add all the source files to your Xcode project:

1. Open `squash-g-ios.xcodeproj` in Xcode
2. Right-click on the `squash-g-ios` group in the Project Navigator
3. Select "Add Files to squash-g-ios..."
4. Select the following folders (make sure "Create groups" is selected):
   - Models
   - ViewModels
   - Views
   - Components
   - Services
   - LiveActivities
   - Theme
   - Extensions
5. Make sure "Copy items if needed" is unchecked (files are already in the project)
6. Click "Add"

### 2. Configure Info.plist

The Info.plist has been created with Live Activities support. Verify it contains:

```xml
<key>NSSupportsLiveActivities</key>
<true/>
<key>NSSupportsLiveActivitiesFrequentUpdates</key>
<true/>
```

### 3. Build and Run

1. Select your target device or simulator (iOS 17.0+)
2. Press ⌘+R to build and run
3. The app will start with a splash screen and transition to the main interface

## Features Overview

### Home Screen
- Select Player A and Player B
- Configure match settings (target score, win by two, tie-break mode)
- Start a new match
- Resume active match if one exists

### Scoreboard
- Large tap areas for quick scoring
- Real-time timer
- Undo last point
- Automatic win detection
- Winner celebration with confetti
- ELO rating updates

### Players
- View all players sorted by ELO
- Detailed player statistics
- Win/loss records
- Player-specific match history
- Add new players with photos

### History
- Complete match history
- Detailed match information
- ELO change tracking
- Manual match entry
- Delete matches with confirmation

### Live Activities
- Lock Screen integration
- Dynamic Island support (iPhone 14 Pro+)
- Real-time score updates
- Match timer display

## Theme & Design

The app uses a **dark neon** aesthetic:

- **Background**: #0A0A0D (deep dark)
- **Primary Neon**: #00FFD1 (cyan)
- **Secondary Neon**: #FF3AD0 (magenta)
- **Accent Blue**: #39A1FF (blue)

UI features:
- Glass morphism effects with .ultraThinMaterial
- Subtle neon glows and shadows
- Smooth animations (0.2-0.35s easeInOut)
- Haptic feedback on interactions
- Premium Apple-like polish

## ELO Rating System

The app uses a standard ELO rating system:
- Default starting rating: 1200
- K-factor: 32
- Ratings update automatically after each match
- Expected score calculation based on rating difference

## Notes

- Live Activities require iOS 16.1+ on physical devices
- Dynamic Island features require iPhone 14 Pro or later
- SwiftData persistence is automatic
- Active match state survives app termination

## License

This is a demonstration project. Use as needed.

---

Built with ❤️ using SwiftUI
