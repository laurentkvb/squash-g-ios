import SwiftUI
import SwiftData

struct ManualSetView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = ManualSetViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                SquashGColors.appBackgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Player A
                        PlayerCard(title: "Player A", player: viewModel.selectedPlayerA) {
                            viewModel.showPlayerASelector = true
                        }
                        
                        // Player B
                        PlayerCard(title: "Player B", player: viewModel.selectedPlayerB) {
                            viewModel.showPlayerBSelector = true
                        }
                        
                        // Scores
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Score")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white.opacity(0.6))
                            
                            HStack(spacing: 16) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Player A")
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundColor(.white.opacity(0.6))
                                    
                                    TextField("0", text: $viewModel.scoreA)
                                        .keyboardType(.numberPad)
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(.white)
                                        .padding(12)
                                        .background(Color.white.opacity(0.05))
                                        .cornerRadius(12)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(SquashGColors.neonTeal.opacity(0.3), lineWidth: 1)
                                        )
                                }
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Player B")
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundColor(.white.opacity(0.6))
                                    
                                    TextField("0", text: $viewModel.scoreB)
                                        .keyboardType(.numberPad)
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(.white)
                                        .padding(12)
                                        .background(Color.white.opacity(0.05))
                                        .cornerRadius(12)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(SquashGColors.neonCyan.opacity(0.3), lineWidth: 1)
                                        )
                                }
                            }
                        }
                        .padding(20)
                        .squashGCard()
                        
                        // Date Picker
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Match Date & Time")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white.opacity(0.6))
                            
                            DatePicker("", selection: $viewModel.matchDate, displayedComponents: [.date, .hourAndMinute])
                                .datePickerStyle(.compact)
                                .tint(SquashGColors.neonTeal)
                                .colorScheme(.dark)
                        }
                        .padding(20)
                        .squashGCard()
                        
                        // Notes
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Notes (Optional)")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white.opacity(0.6))
                            
                            TextEditor(text: $viewModel.notes)
                                .font(.system(size: 15, weight: .regular))
                                .foregroundColor(.white)
                                .frame(height: 100)
                                .padding(12)
                                .background(Color.white.opacity(0.05))
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(SquashGColors.neonTeal.opacity(0.3), lineWidth: 1)
                                )
                                .scrollContentBackground(.hidden)
                        }
                        .padding(20)
                        .squashGCard()
                        
                        // Save Button
                        NeonButton(
                            title: "Save Match",
                            borderColor: SquashGColors.neonTeal,
                            action: {
                                viewModel.saveMatch(modelContext: modelContext)
                                dismiss()
                            },
                            isEnabled: viewModel.isValid
                        )
                    }
                    .padding(20)
                    .padding(.bottom, 100)
                    }
                }
            .centeredNavTitle("Add Manual Set")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(SquashGColors.neonCyan)
                }
            }
            .sheet(isPresented: $viewModel.showPlayerASelector) {
                PlayerSelectorView(
                    selectedPlayer: $viewModel.selectedPlayerA,
                    excludePlayerId: viewModel.selectedPlayerB?.id
                )
            }
            .sheet(isPresented: $viewModel.showPlayerBSelector) {
                PlayerSelectorView(
                    selectedPlayer: $viewModel.selectedPlayerB,
                    excludePlayerId: viewModel.selectedPlayerA?.id
                )
            }
            .onTapGesture {
                hideKeyboard()
            }
        }
    }
}

#Preview {
    ManualSetView()
        .modelContainer(for: [Player.self, MatchRecord.self])
}
