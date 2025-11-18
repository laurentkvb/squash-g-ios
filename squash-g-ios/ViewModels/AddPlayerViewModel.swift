
import Foundation
import SwiftUI
import Combine

@MainActor
class AddPlayerViewModel: ObservableObject {
    @Published var playerName = ""
    @Published var selectedAvatar: UIImage?
    @Published var showImagePicker = false
    
    var isValid: Bool {
        !playerName.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    func savePlayer(modelContext: ModelContext) {
        guard isValid else { return }
        
        let avatarData = selectedAvatar?.jpegData(compressionQuality: 0.8)
        
        let player = Player(
            name: playerName.trimmingCharacters(in: .whitespaces),
            avatarData: avatarData
        )
        
        modelContext.insert(player)
        try? modelContext.save()
        
        HapticService.shared.success()
    }
}

import SwiftData
