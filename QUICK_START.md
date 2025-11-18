# SquashG - Quick Start Checklist

## ✅ Setup Checklist

Follow these steps to get SquashG running:

### Step 1: Verify Files ✓
```bash
./verify_project.sh
```
Expected output: **40 Swift files** across 8 directories

---

### Step 2: Add Files to Xcode

**Xcode is already open.** Now add the source files:

1. [ ] Look at **Project Navigator** (left sidebar)
2. [ ] Right-click on **"squash-g-ios"** group (yellow folder)
3. [ ] Select **"Add Files to squash-g-ios..."**
4. [ ] Navigate to: `squash-g-ios/squash-g-ios/`
5. [ ] **Select ALL these folders** (hold ⌘ to multi-select):
   - [ ] Components
   - [ ] Extensions
   - [ ] LiveActivities
   - [ ] Models
   - [ ] Services
   - [ ] Theme
   - [ ] ViewModels
   - [ ] Views
6. [ ] In options panel:
   - [ ] ✅ Check **"Create groups"**
   - [ ] ❌ UN-check **"Copy items if needed"**
   - [ ] ✅ Check **"squash-g-ios"** target
7. [ ] Click **"Add"**

---

### Step 3: Verify Target Membership

1. [ ] Select any `.swift` file in Project Navigator
2. [ ] Open **File Inspector** (⌘+⌥+1) on right side
3. [ ] Under **Target Membership**, verify **"squash-g-ios"** is ✅ checked
4. [ ] If not checked, check it and repeat for a few files

---

### Step 4: Build Project

1. [ ] Press **⌘+B** to build
2. [ ] Wait for build to complete
3. [ ] If errors appear:
   - [ ] Check Target Membership for files mentioned in errors
   - [ ] Clean build folder: **⇧+⌘+K**
   - [ ] Build again: **⌘+B**

---

### Step 5: Run App

1. [ ] Select **iPhone 15 Pro** simulator from device menu
2. [ ] Press **⌘+R** to run
3. [ ] Watch for:
   - [ ] Splash screen appears (2.5 seconds)
   - [ ] Smooth fade to tab bar
   - [ ] Home screen visible

---

## 🎮 First Use

### Add Players
1. [ ] Tap **Players** tab
2. [ ] Tap **"+ Add Player"**
3. [ ] Enter name: "Player 1"
4. [ ] Tap **"Add Player"**
5. [ ] Repeat for "Player 2"

### Start a Match
1. [ ] Tap **Play** tab
2. [ ] Tap **"Select Player A"** → choose Player 1
3. [ ] Tap **"Select Player B"** → choose Player 2
4. [ ] Tap **"Start Set"**

### Play the Match
1. [ ] Tap **left button** to score for Player 1
2. [ ] Tap **right button** to score for Player 2
3. [ ] Play until someone reaches 11 points
4. [ ] Watch winner celebration! 🎉

---

## 🐛 Troubleshooting

### Build Errors

**"Cannot find 'Player' in scope"**
- [ ] Files not added to target
- [ ] Fix: Check Target Membership

**"No such module 'SwiftData'"**
- [ ] iOS target too low
- [ ] Fix: Set deployment target to iOS 17.0+

**Missing Info.plist**
- [ ] Info.plist path not set
- [ ] Fix: Target settings → Info.plist = `squash-g-ios/Info.plist`

---

## ✅ Success Criteria

You've successfully set up SquashG when:

- [ ] Build completes with **0 errors**
- [ ] App launches with **splash screen**
- [ ] Tab bar displays with **3 tabs**
- [ ] Can add **players**
- [ ] Can start a **match**
- [ ] Can score **points**
- [ ] See **winner screen** after match

---

## 🎯 What You'll See

### On Launch
```
[Splash Screen]
   SquashG
Score. Compete. Dominate.
(2.5 second animation)
      ↓
[Main Tab View]
┌─────────────────────┐
│   Play │ History │ Players
│   ──────            
└─────────────────────┘
```

### Home Screen
```
┌─────────────────────────┐
│  Select Player A        │
│  [person icon]          │
└─────────────────────────┘

┌─────────────────────────┐
│  Select Player B        │
│  [person icon]          │
└─────────────────────────┘

┌─────────────────────────┐
│  Match Settings         │
│  Target Score: 11       │
│  Win by Two: ON         │
└─────────────────────────┘

┌─────────────────────────┐
│      Start Set          │
└─────────────────────────┘
```

### Scoreboard
```
┌──────────────────────┐
│   [X]  00:00  [↶]   │
├──────────────────────┤
│                      │
│   John      Jane     │
│     7    –    6      │
│                      │
├──────────────────────┤
│  [+1]         [+1]   │
│  John         Jane   │
└──────────────────────┘
```

---

## 📚 Documentation

- **PROJECT_SUMMARY.md** - Complete overview
- **IMPLEMENTATION_GUIDE.md** - Detailed setup
- **README.md** - Feature documentation

---

## 🚀 You're Ready!

Once all checkboxes are ✅, you have a fully functional squash tracking app!

**Enjoy SquashG!** 🎾
