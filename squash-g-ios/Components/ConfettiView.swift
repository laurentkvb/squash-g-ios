import SwiftUI

struct ConfettiView: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            ForEach(0..<50, id: \.self) { index in
                ConfettiPiece(index: index, animate: animate)
            }
        }
        .onAppear {
            animate = true
        }
    }
}

struct ConfettiPiece: View {
    let index: Int
    let animate: Bool
    
    @State private var yOffset: CGFloat = -100
    @State private var xOffset: CGFloat = 0
    @State private var rotation: Double = 0
    @State private var opacity: Double = 1
    
    private let colors: [Color] = [
        SquashGColors.neonCyan,
        SquashGColors.neonPink,
        SquashGColors.neonTeal,
        SquashGColors.goldAccent,
        SquashGColors.neonCyan.opacity(0.8)
    ]
    
    var body: some View {
        Rectangle()
            .fill(colors[index % colors.count])
            .frame(width: 10, height: 10)
            .rotationEffect(.degrees(rotation))
            .opacity(opacity)
            .offset(x: xOffset, y: yOffset)
            .onAppear {
                let randomDelay = Double.random(in: 0...0.3)
                let randomDuration = Double.random(in: 1.5...3.0)
                let randomXOffset = CGFloat.random(in: -150...150)
                let randomRotation = Double.random(in: 0...720)
                
                let screenHeight: CGFloat
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let screen = windowScene.windows.first?.windowScene?.screen {
                    screenHeight = screen.bounds.height
                } else {
                    screenHeight = 1000 // fallback
                }
                withAnimation(
                    .easeOut(duration: randomDuration)
                        .delay(randomDelay)
                ) {
                    yOffset = screenHeight + 100
                    xOffset = randomXOffset
                    rotation = randomRotation
                    opacity = 0
                }
            }
    }
}

#Preview {
    ConfettiView()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(SquashGColors.appBackgroundGradient)
}
