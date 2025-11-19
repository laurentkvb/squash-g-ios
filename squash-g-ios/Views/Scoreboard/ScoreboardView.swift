import SwiftUI
import SwiftData

struct ScoreboardView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: ScoreboardViewModel
    @State private var showEndConfirmation = false
    @State private var showWinnerSheet = false
    
    init(match: ActiveMatch) {
        _viewModel = StateObject(wrappedValue: ScoreboardViewModel(match: match))
    }
    
    var body: some View {
        ZStack {
            SquashGColors.appBackgroundGradient
                .ignoresSafeArea()
            
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    // Top Bar
                    HStack {
                        Button(action: {
                            showEndConfirmation = true
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 28))
                                .foregroundColor(.white.opacity(0.7))
                        }
                        
                        Spacer()
                        
                        // Timer
                        HStack(spacing: 6) {
                            Image(systemName: "clock.fill")
                                .font(.system(size: 14))
                            Text(viewModel.timerService.formattedTime)
                                .font(.system(size: 16, weight: .semibold))
                                .monospacedDigit()
                        }
                        .foregroundColor(.white.opacity(0.7))
                        
                        Spacer()
                        
                        Button(action: {
                            viewModel.undoLastPoint()
                        }) {
                            Image(systemName: "arrow.uturn.backward.circle.fill")
                                .font(.system(size: 28))
                                .foregroundColor(viewModel.canUndo ? SquashGColors.neonCyan : SquashGColors.textSecondary)
                        }
                        .disabled(!viewModel.canUndo)
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 16)
                    
                    // Match Info (Mode, Set, Set Score)
                    VStack(spacing: 8) {
                        // Match Mode
                        Text(viewModel.match.settings.matchMode.rawValue)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.white.opacity(0.5))
                        
                        // Current Set
                        Text("Set \(viewModel.match.currentSetNumber) of \(viewModel.match.settings.matchMode.totalSets)")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white.opacity(0.4))
                        
                        // Set Score Summary
                        if viewModel.match.settings.matchMode != .bestOf1 {
                            HStack(spacing: 8) {
                                Text(viewModel.match.playerAName)
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.white.opacity(0.6))
                                
                                HStack(spacing: 4) {
                                    Text("\(viewModel.match.setsWonA)")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(SquashGColors.neonCyan)
                                    
                                    Text("–")
                                        .font(.system(size: 12, weight: .light))
                                        .foregroundColor(.white.opacity(0.3))
                                    
                                    Text("\(viewModel.match.setsWonB)")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(SquashGColors.neonPurple)
                                }
                                .monospacedDigit()
                                
                                Text(viewModel.match.playerBName)
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.white.opacity(0.6))
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                Capsule()
                                    .fill(Color.white.opacity(0.05))
                            )
                        }
                    }
                    .padding(.bottom, 20)
                    
                    Spacer()
                    
                    // Center Score Display
                    HStack(spacing: 40) {
                        // Player A
                        VStack(spacing: 12) {
                            Text(viewModel.match.playerAName)
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                            
                                AdaptiveText(
                                    text: "\(viewModel.match.scoreA)",
                                    maxFontSize: 72,
                                    weight: .heavy,
                                    textColor: UIColor(SquashGColors.neonCyan),
                                    minimumScaleFactor: 0.35,
                                    isMonospacedDigits: true
                                )
                                .scaleEffect(0.8)
                                .shadow(color: SquashGColors.neonCyan.opacity(0.6), radius: 20)
                        }
                        .frame(maxWidth: .infinity)
                        
                        // Divider
                        Rectangle()
                            .fill(.white.opacity(0.2))
                            .frame(width: 2, height: 100)
                        
                        // Player B
                        VStack(spacing: 12) {
                            Text(viewModel.match.playerBName)
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                            
                            AdaptiveText(
                                text: "\(viewModel.match.scoreB)",
                                maxFontSize: 72,
                                weight: .heavy,
                                textColor: UIColor(SquashGColors.neonPurple),
                                minimumScaleFactor: 0.35,
                                isMonospacedDigits: true
                            )
                            .scaleEffect(0.8)
                            .shadow(color: SquashGColors.neonPurple.opacity(0.6), radius: 20)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal, 24)
                    
                    Spacer()
                    
                    // Score Buttons
                    HStack(spacing: 16) {
                        // Player A Button
                        ScoreButton(
                            playerName: viewModel.match.playerAName,
                            color: SquashGColors.neonCyan
                        ) {
                            viewModel.addPointToPlayerA()
                        }
                        
                        // Player B Button
                        ScoreButton(
                            playerName: viewModel.match.playerBName,
                            color: SquashGColors.neonPurple
                        ) {
                            viewModel.addPointToPlayerB()
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 40)
                }
            }
            
            // Set Win Banner
            if viewModel.showSetWinBanner, let winnerName = viewModel.setWinnerName, let setNumber = viewModel.completedSetNumber {
                VStack {
                    Spacer()
                    
                    VStack(spacing: 12) {
                        Text("\(winnerName) wins")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Set \(setNumber)")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(SquashGColors.neonCyan)
                    }
                    .padding(.vertical, 24)
                    .padding(.horizontal, 40)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.black.opacity(0.9))
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(SquashGColors.neonCyan, lineWidth: 2)
                            )
                            .shadow(color: SquashGColors.neonCyan.opacity(0.5), radius: 20)
                    )
                    .transition(.scale.combined(with: .opacity))
                    
                    Spacer()
                }
                .zIndex(10)
            }
        }
        .onAppear {
            // Ensure local presentation state matches the view model's state
            // (handles the case where the restored match was already finished)
            if viewModel.showWinnerScreen {
                showWinnerSheet = true
            }
        }
        .confirmationDialog("End Match?", isPresented: $showEndConfirmation) {
            Button("End & Save Match", role: .destructive) {
                viewModel.endAndSaveMatch(modelContext: modelContext)
                dismiss()
            }
            Button("Cancel", role: .cancel) {}
        }
        .sheet(isPresented: $showWinnerSheet) {
            WinnerView(
                winnerName: viewModel.winnerName ?? "",
                scoreA: viewModel.match.setsWonA,
                scoreB: viewModel.match.setsWonB,
                playerAName: viewModel.match.playerAName,
                playerBName: viewModel.match.playerBName,
                eloChangeA: viewModel.eloChangeA,
                eloChangeB: viewModel.eloChangeB,
                onDone: {
                    viewModel.showWinnerScreen = false
                    showWinnerSheet = false
                    viewModel.endAndSaveMatch(modelContext: modelContext)
                    dismiss()
                },
                onRematch: {
                    // End & save the finished match
                    viewModel.endAndSaveMatch(modelContext: modelContext)

                    // Prepare a fresh rematch and start it globally
                    let newMatch = viewModel.rematch()
                    ActiveMatchService.shared.startMatch(
                        playerAId: newMatch.playerAId,
                        playerBId: newMatch.playerBId,
                        playerAName: newMatch.playerAName,
                        playerBName: newMatch.playerBName,
                        settings: newMatch.settings
                    )

                    LiveActivityService.shared.startActivity(
                        playerAName: newMatch.playerAName,
                        playerBName: newMatch.playerBName,
                        startDate: newMatch.startDate
                    )

                    // Keep the user on the scoreboard: update the current view model to the new match
                    viewModel.match = newMatch
                    viewModel.timerService.stop()
                    viewModel.timerService.start(from: newMatch.startDate)

                    // Close the winner sheet but do NOT dismiss the Scoreboard view — user stays on the live scoreboard
                    viewModel.showWinnerScreen = false
                    showWinnerSheet = false
                }
            )
            // Lock the sheet to a single detent and disable interactive dismissal so it cannot be dragged down
            .presentationDetents([.large])
            .presentationDragIndicator(.hidden)
            .interactiveDismissDisabled(true)
        }
        .onChange(of: viewModel.showWinnerScreen) { _, newValue in
            if newValue {
                // Present the winner sheet immediately; confetti will play inside WinnerView
                showWinnerSheet = true
            } else {
                // Dismiss local sheet if view model cleared
                showWinnerSheet = false
            }
        }
    }
}

struct ScoreButton: View {
    let playerName: String
    let color: Color
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            action()
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = false
                }
            }
        }) {
            VStack(spacing: 8) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 32))
                    .foregroundColor(color)
                
                Text("+1")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white.opacity(0.05))
            .cornerRadius(24)
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(color, lineWidth: 2)
            )
            .shadow(color: color.opacity(isPressed ? 0.8 : 0.4), radius: isPressed ? 24 : 12)
            .scaleEffect(isPressed ? 0.96 : 1.0)
        }
        .frame(height: 120)
    }
}

#Preview {
    ScoreboardView(match: ActiveMatch(
        playerAId: UUID(),
        playerBId: UUID(),
        playerAName: "John",
        playerBName: "Jane",
        scoreA: 7,
        scoreB: 6,
        startDate: Date(),
        settings: MatchSettings(),
        scoreHistory: [],
        setsWonA: 0,
        setsWonB: 0,
        completedSets: [],
        currentSetNumber: 1
    ))
    .modelContainer(for: [Player.self, MatchRecord.self])
}
