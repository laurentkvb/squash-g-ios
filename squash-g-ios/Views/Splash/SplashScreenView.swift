import SwiftUI

struct SplashScreenView: View {
    @State private var scale: CGFloat = 0.95
    @State private var opacity: Double = 0
    @Binding var showMain: Bool
    
    var body: some View {
        ZStack {
            SquashGColors.appBackgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                Text("SquashG")
                    .font(.system(size: 56, weight: .heavy))
                    .foregroundColor(SquashGColors.neonCyan)
                    .shadow(color: SquashGColors.neonCyan.opacity(0.85), radius: 25)
                    .shadow(color: SquashGColors.neonCyan.opacity(0.5), radius: 40)
                    .scaleEffect(scale)
                    .opacity(opacity)
                
                Text("Score. Compete. Dominate.")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
                    .opacity(opacity)
            }
        }
        .onAppear {
            HapticService.shared.light()
            
            // Fade in and pulse animation
            withAnimation(.easeInOut(duration: 0.8)) {
                opacity = 1
                scale = 1.0
            }
            
            // Slight pulse
            withAnimation(
                .easeInOut(duration: 1.0)
                .repeatCount(2, autoreverses: true)
                .delay(0.8)
            ) {
                scale = 1.05
            }
            
            // Fade out and transition to main
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation(.easeOut(duration: 0.6)) {
                    opacity = 0
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    showMain = true
                }
            }
        }
    }
}

#Preview {
    SplashScreenView(showMain: .constant(false))
}
