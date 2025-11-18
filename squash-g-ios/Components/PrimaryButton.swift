import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    var isEnabled: Bool = true

    var body: some View {
        Button(action: {
            guard isEnabled else { return }
            HapticService.shared.light()
            action()
        }) {
            Text(title)
                .primaryCTA()
        }
        .disabled(!isEnabled)
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal)
    }
}

#Preview {
    VStack {
        PrimaryButton(title: "Start Set", action: {})
    }
    .background(SquashGColors.appBackgroundGradient.ignoresSafeArea())
}
