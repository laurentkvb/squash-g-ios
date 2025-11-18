
import SwiftUI
import PhotosUI
import SwiftData

struct AddPlayerView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = AddPlayerViewModel()
    @State private var selectedItem: PhotosPickerItem?
    
    var body: some View {
        NavigationStack {
            ZStack {
                SquashGColors.appBackgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Avatar Picker
                        PhotosPicker(selection: $selectedItem, matching: .images) {
                            ZStack {
                                if let avatar = viewModel.selectedAvatar {
                                    Image(uiImage: avatar)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 120, height: 120)
                                        .clipShape(Circle())
                                        .overlay(
                                            Circle()
                                                .stroke(SquashGColors.neonCyan, lineWidth: 3)
                                        )
                                } else {
                                    ZStack {
                                        Circle()
                                            .fill(Color.white.opacity(0.05))
                                            .frame(width: 120, height: 120)
                                        
                                        VStack(spacing: 8) {
                                            Image(systemName: "person.fill.badge.plus")
                                                .font(.system(size: 40))
                                                .foregroundColor(SquashGColors.neonCyan.opacity(0.6))
                                            
                                            Text("Add Photo")
                                                .font(.system(size: 12, weight: .medium))
                                                .foregroundColor(.white.opacity(0.6))
                                        }
                                    }
                                    .overlay(
                                        Circle()
                                            .stroke(SquashGColors.neonCyan.opacity(0.3), lineWidth: 2)
                                    )
                                }
                            }
                        }
                        .onChange(of: selectedItem) { _, newValue in
                            Task {
                                if let data = try? await newValue?.loadTransferable(type: Data.self),
                                   let image = UIImage(data: data) {
                                    viewModel.selectedAvatar = image
                                }
                            }
                        }
                        .padding(.top, 20)
                        
                        // Name Input
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Player Name")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white.opacity(0.6))
                            
                            TextField("Enter name", text: $viewModel.playerName)
                                .font(.system(size: 18, weight: .regular))
                                .foregroundColor(.white)
                                .padding(16)
                                .background(Color.white.opacity(0.05))
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(SquashGColors.neonCyan.opacity(0.3), lineWidth: 1)
                                )
                        }
                        
                        Spacer(minLength: 40)
                        
                        // Save Button
                        NeonButton(
                            title: "Add Player",
                            borderColor: SquashGColors.neonCyan,
                            action: {
                                viewModel.savePlayer(modelContext: modelContext)
                                dismiss()
                            },
                            isEnabled: viewModel.isValid
                        )
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Add Player")
            .navigationBarTitleDisplayMode(.inline)
            .centeredNavTitle("Add Player")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(SquashGColors.neonCyan)
                }
            }
        }
    }
}

#Preview {
    AddPlayerView()
        .modelContainer(for: [Player.self, MatchRecord.self])
}
