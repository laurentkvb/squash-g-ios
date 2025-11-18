# SquashG - Complete File Structure

## 📁 Project Directory Tree

```
squash-g-ios/
├── squash-g-ios.xcodeproj/          # Xcode project file
│   └── project.pbxproj
│
├── squash-g-ios/                    # Main app folder
│   │
│   ├── squash_g_iosApp.swift        # ✨ App entry point (UPDATED)
│   ├── ContentView.swift            # (Original - can delete)
│   ├── Info.plist                   # ✨ Live Activities config (NEW)
│   │
│   ├── Models/                      # 📦 SwiftData Models (4 files)
│   │   ├── Player.swift
│   │   ├── MatchRecord.swift
│   │   ├── MatchSettings.swift
│   │   └── ActiveMatch.swift
│   │
│   ├── ViewModels/                  # 🧠 Business Logic (6 files)
│   │   ├── HomeViewModel.swift
│   │   ├── ScoreboardViewModel.swift
│   │   ├── PlayersViewModel.swift
│   │   ├── PlayerDetailViewModel.swift
│   │   ├── AddPlayerViewModel.swift
│   │   └── ManualSetViewModel.swift
│   │
│   ├── Views/                       # 🎨 UI Views (13 files)
│   │   ├── MainTabView.swift
│   │   │
│   │   ├── Splash/
│   │   │   └── SplashScreenView.swift
│   │   │
│   │   ├── Home/
│   │   │   ├── HomeView.swift
│   │   │   └── PlayerSelectorView.swift
│   │   │
│   │   ├── Scoreboard/
│   │   │   ├── ScoreboardView.swift
│   │   │   └── WinnerView.swift
│   │   │
│   │   ├── Players/
│   │   │   ├── PlayersView.swift
│   │   │   ├── PlayerDetailView.swift
│   │   │   ├── PlayerMatchHistoryView.swift
│   │   │   └── AddPlayerView.swift
│   │   │
│   │   └── History/
│   │       ├── HistoryView.swift
│   │       ├── MatchDetailView.swift
│   │       └── ManualSetView.swift
│   │
│   ├── Components/                  # 🧩 Reusable UI (5 files)
│   │   ├── NeonButton.swift
│   │   ├── PlayerCard.swift
│   │   ├── SettingsCard.swift
│   │   ├── ActiveMatchCard.swift
│   │   └── ConfettiView.swift
│   │
│   ├── Services/                    # ⚙️ Business Services (4 files)
│   │   ├── ELOService.swift
│   │   ├── HapticService.swift
│   │   ├── TimerService.swift
│   │   └── ActiveMatchService.swift
│   │
│   ├── LiveActivities/              # 📱 Live Activities (3 files)
│   │   ├── MatchActivityAttributes.swift
│   │   ├── LiveActivityService.swift
│   │   └── MatchActivityWidget.swift
│   │
│   ├── Theme/                       # 🎨 Styling (1 file)
│   │   └── Theme.swift
│   │
│   ├── Extensions/                  # 🔧 Helpers (2 files)
│   │   ├── Date+Extensions.swift
│   │   └── View+Extensions.swift
│   │
│   └── Assets.xcassets/             # 🖼️ Assets
│       ├── AppIcon.appiconset/
│       └── AccentColor.colorset/
│
├── README.md                        # 📖 Project overview
├── IMPLEMENTATION_GUIDE.md          # 📘 Detailed setup guide
├── PROJECT_SUMMARY.md               # 📋 Complete summary
├── QUICK_START.md                   # ⚡ Quick start checklist
└── verify_project.sh                # ✅ Verification script
```

## 📊 File Count Summary

| Category | Count | Description |
|----------|-------|-------------|
| **Models** | 4 | SwiftData models for persistence |
| **ViewModels** | 6 | MVVM business logic layer |
| **Views** | 13 | SwiftUI user interface screens |
| **Components** | 5 | Reusable UI components |
| **Services** | 4 | Business logic services |
| **LiveActivities** | 3 | Lock Screen / Dynamic Island |
| **Theme** | 1 | App-wide styling and colors |
| **Extensions** | 2 | Swift helper extensions |
| **App Entry** | 1 | Main app file (updated) |
| **Config** | 1 | Info.plist with Live Activities |
| **Total Swift** | **40** | Complete source code files |

## 🎯 Key Files to Review

### Essential App Files
- `squash_g_iosApp.swift` - SwiftData container setup, splash screen logic
- `MainTabView.swift` - Custom glass tab bar implementation
- `Info.plist` - Live Activities configuration

### Core Features
- `ScoreboardView.swift` - Main match tracking interface
- `ELOService.swift` - Rating calculation algorithm
- `LiveActivityService.swift` - Lock Screen integration

### UI Polish
- `Theme.swift` - Dark neon color scheme, view modifiers
- `SplashScreenView.swift` - Animated app intro
- `ConfettiView.swift` - Winner celebration

### Data Layer
- `Player.swift` - Player model with ELO rating
- `MatchRecord.swift` - Match history with stats
- `ActiveMatchService.swift` - Match state persistence

## 📱 Feature → File Mapping

| Feature | Primary Files |
|---------|---------------|
| **Player Management** | `Player.swift`, `PlayersViewModel.swift`, `PlayersView.swift`, `AddPlayerView.swift` |
| **Match Tracking** | `ActiveMatch.swift`, `ScoreboardViewModel.swift`, `ScoreboardView.swift` |
| **ELO System** | `ELOService.swift`, `MatchRecord.swift` |
| **Live Activities** | `MatchActivityAttributes.swift`, `LiveActivityService.swift`, `MatchActivityWidget.swift` |
| **Match History** | `MatchRecord.swift`, `HistoryView.swift`, `MatchDetailView.swift` |
| **Dark Neon UI** | `Theme.swift`, all view files |
| **Custom Tab Bar** | `MainTabView.swift` |
| **Splash Screen** | `SplashScreenView.swift` |

## 🔍 File Purposes

### Models Layer
| File | Purpose |
|------|---------|
| `Player.swift` | Player entity with name, avatar, ELO rating |
| `MatchRecord.swift` | Historical match with scores and ELO changes |
| `MatchSettings.swift` | Match rules (target score, win by 2, tie-break) |
| `ActiveMatch.swift` | Live match state with score history |

### ViewModels Layer
| File | Purpose |
|------|---------|
| `HomeViewModel.swift` | Player selection, match settings, start logic |
| `ScoreboardViewModel.swift` | Live scoring, timer, win detection, ELO update |
| `PlayersViewModel.swift` | Player list sorting, statistics calculation |
| `PlayerDetailViewModel.swift` | Individual player stats and match history |
| `AddPlayerViewModel.swift` | New player creation with validation |
| `ManualSetViewModel.swift` | Historical match entry with ELO calculation |

### Views Layer
| File | Purpose |
|------|---------|
| `SplashScreenView.swift` | Animated intro with neon logo |
| `MainTabView.swift` | Custom glass tab bar with 3 tabs |
| `HomeView.swift` | Player selection and match start |
| `PlayerSelectorView.swift` | Player selection sheet |
| `ScoreboardView.swift` | Live match interface with scoring |
| `WinnerView.swift` | Winner celebration with ELO changes |
| `PlayersView.swift` | Player list sorted by ELO |
| `PlayerDetailView.swift` | Player stats and details |
| `PlayerMatchHistoryView.swift` | Filtered match history |
| `AddPlayerView.swift` | New player form |
| `HistoryView.swift` | Complete match history list |
| `MatchDetailView.swift` | Individual match details |
| `ManualSetView.swift` | Manual match entry form |

### Components Layer
| File | Purpose |
|------|---------|
| `NeonButton.swift` | Reusable button with neon border and pulse |
| `PlayerCard.swift` | Player selection card with avatar |
| `SettingsCard.swift` | Match configuration UI |
| `ActiveMatchCard.swift` | Active match display card |
| `ConfettiView.swift` | Particle animation for winner |

### Services Layer
| File | Purpose |
|------|---------|
| `ELOService.swift` | ELO rating calculations (K=32) |
| `HapticService.swift` | Haptic feedback (light, medium, success) |
| `TimerService.swift` | Match timer with formatting |
| `ActiveMatchService.swift` | Match state persistence to UserDefaults |

### LiveActivities Layer
| File | Purpose |
|------|---------|
| `MatchActivityAttributes.swift` | Live Activity data structure |
| `LiveActivityService.swift` | Start/update/end Live Activities |
| `MatchActivityWidget.swift` | Lock Screen + Dynamic Island UI |

### Theme Layer
| File | Purpose |
|------|---------|
| `Theme.swift` | Colors, view modifiers, neon effects |

### Extensions Layer
| File | Purpose |
|------|---------|
| `Date+Extensions.swift` | Date formatting (timeAgo, elapsedTime) |
| `View+Extensions.swift` | Keyboard dismissal helper |

## 🎨 Visual Structure

```
┌─────────────────────────────────────────┐
│           squash_g_iosApp.swift         │  Entry Point
│      (SwiftData + Splash Logic)         │
└────────────────┬────────────────────────┘
                 │
        ┌────────▼────────┐
        │ SplashScreenView │  2.5s Animation
        └────────┬────────┘
                 │
        ┌────────▼────────┐
        │  MainTabView     │  Custom Tab Bar
        └────┬─────┬──┬───┘
             │     │  │
    ┌────────▼┐ ┌─▼──▼─────┐ ┌──────────▼┐
    │ HomeView│ │HistoryView│ │PlayersView│
    └─────┬───┘ └─────┬─────┘ └─────┬─────┘
          │           │              │
    ┌─────▼──────┐    │     ┌────────▼─────────┐
    │ Scoreboard │    │     │  PlayerDetailView │
    └────────────┘    │     └──────────────────┘
                      │
              ┌───────▼───────┐
              │ MatchDetailView│
              └───────────────┘
```

## ✅ Verification

Run to verify all files are present:
```bash
./verify_project.sh
```

Expected output:
```
✅ Models: 4 files
✅ ViewModels: 6 files
✅ Views: 13 files
✅ Components: 5 files
✅ Services: 4 files
✅ LiveActivities: 3 files
✅ Theme: 1 files
✅ Extensions: 2 files
📊 Total Swift files: 40
```

---

**All files are created and organized!** 🎉

See `QUICK_START.md` for setup steps.
