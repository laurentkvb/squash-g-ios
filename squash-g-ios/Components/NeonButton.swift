import SwiftUI

struct NeonButton: View {
    let title: String
    let borderColor: Color
    let action: () -> Void
    var isEnabled: Bool = true
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            guard isEnabled else { return }
            HapticService.shared.light()
            action()
        }) {
            Text(title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(isEnabled ? .white : .white.opacity(0.4))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .squashGNeonButton(borderColor: isEnabled ? borderColor : borderColor.opacity(0.3), isPressed: isPressed, isEnabled: isEnabled)
        }
        .disabled(!isEnabled)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !isPressed && isEnabled {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    isPressed = false
                }
        )
    }
}

#Preview {
    VStack(spacing: 20) {
        NeonButton(title: "Start Match", borderColor: SquashGColors.neonCyan, action: {
            print("Tapped")
        })
        
        NeonButton(title: "Disabled", borderColor: SquashGColors.neonCyan, action: {
            print("Tapped")
        }, isEnabled: false)
    }
    .padding()
    .background(SquashGColors.appBackgroundGradient)
}
