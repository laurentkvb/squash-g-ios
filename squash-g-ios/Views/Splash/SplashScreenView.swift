import SwiftUI
import UIKit

struct SplashScreenView: View {
    @State private var scale: CGFloat = 0.95
    @State private var opacity: Double = 0
    // Attempt to load a bundled logo image if it exists. Returns nil when
    // no image asset is available so the view falls back to a text title.
    static func loadLogoImage() -> UIImage? {
        // Common asset name fallbacks — harmless if they don't exist.
        let candidates = ["AppIcon", "AppIcon60x60", "squash_icon", "squash_logo", "Logo"]
        for name in candidates {
            if let img = UIImage(named: name) {
                return img
            }
        }

        // Try loading an image directly from the bundle by filename (e.g. png)
        for name in candidates {
            if let url = Bundle.main.url(forResource: name, withExtension: "png"),
               let data = try? Data(contentsOf: url),
               let img = UIImage(data: data) {
                return img
            }
        }

        return nil
    }
    @State private var rotation: Double = 0
    @State private var glowScale: CGFloat = 0.8
    @Binding var showMain: Bool
    
    var body: some View {
        ZStack {
            SquashGColors.appBackgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                if let uiLogo = SplashScreenView.loadLogoImage() {
                    VStack(spacing: 10) {
                        ZStack {
                            // soft neon glow behind the logo
                            Circle()
                                .fill(SquashGColors.neonCyan.opacity(0.12))
                                .frame(width: 220, height: 220)
                                .scaleEffect(glowScale)
                                .blur(radius: 18)

                            Image(uiImage: uiLogo)
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 160, maxHeight: 160)
                                .shadow(color: SquashGColors.neonCyan.opacity(0.85), radius: 25)
                                .scaleEffect(scale)
                                .rotationEffect(.degrees(rotation))
                                .opacity(opacity)
                        }

                        // Re-add the original app title under the logo
                        Text("SquashG")
                            .font(.system(size: 36, weight: .heavy))
                            .foregroundColor(SquashGColors.neonCyan)
                            .shadow(color: SquashGColors.neonCyan.opacity(0.85), radius: 20)
                            .shadow(color: SquashGColors.neonCyan.opacity(0.45), radius: 30)
                            .scaleEffect(scale)
                            .opacity(opacity)
                    }
                } else {
                    Text("SquashG")
                        .font(.system(size: 56, weight: .heavy))
                        .foregroundColor(SquashGColors.neonCyan)
                        .shadow(color: SquashGColors.neonCyan.opacity(0.85), radius: 25)
                        .shadow(color: SquashGColors.neonCyan.opacity(0.5), radius: 40)
                        .scaleEffect(scale)
                        .opacity(opacity)
                }

                Text("Score. Compete. Dominate.")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
                    .opacity(opacity)
            }
        }
        .onAppear {
            HapticService.shared.light()
            
            // Fade in and primary scale/rotation animation
            withAnimation(.spring(response: 0.7, dampingFraction: 0.8)) {
                opacity = 1
                scale = 1.02
                rotation = 0
                glowScale = 1.0
            }

            // Gentle pulse + tiny rotation loop
            withAnimation(
                .easeInOut(duration: 1.0)
                .repeatCount(3, autoreverses: true)
                .delay(0.6)
            ) {
                scale = 1.06
                rotation = 6
                glowScale = 1.08
            }
            
            // Fade out and transition to main
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation(.easeOut(duration: 0.6)) {
                    opacity = 0
                    glowScale = 0.9
                    rotation = 0
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    showMain = true
                }
            }
        }
    }

    // No logo: splash uses text title only
}

#Preview {
    SplashScreenView(showMain: .constant(false))
}
