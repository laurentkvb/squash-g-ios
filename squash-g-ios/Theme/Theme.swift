
import SwiftUI

// SquashG Theme and color system
struct SquashGColors {
    static let backgroundDark   = Color(hex: "081A2D")   // deep navy
    static let backgroundDarker = Color(hex: "0B2237")   // gradient bottom
    static let cardDark         = Color(hex: "0E314B")   // card surfaces
    static let tabDark          = Color(hex: "06131F")   // bottom bar

    static let neonCyan         = Color(hex: "00D1FF")
    static let neonTeal         = Color(hex: "00E3CC")
    static let neonPink         = Color(hex: "FF00CC")   // CTA + logo ball
    static let goldAccent       = Color(hex: "FFC83D")   // toggles, steppers

    static let textPrimary      = Color.white
    static let textSecondary    = Color.white.opacity(0.7)

    static var appBackgroundGradient: LinearGradient {
        LinearGradient(
            colors: [SquashGColors.backgroundDark, SquashGColors.backgroundDarker],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

// Backwards-compatible AppTheme for existing code
struct AppTheme {
    static let backgroundDark = SquashGColors.backgroundDark
    static let backgroundDarker = SquashGColors.backgroundDarker
    static let cardDark = SquashGColors.cardDark
    static let tabDark = SquashGColors.tabDark

    static let neonCyan = SquashGColors.neonCyan
    static let neonTeal = SquashGColors.neonTeal
    static let neonPink = SquashGColors.neonPink
    static let goldAccent = SquashGColors.goldAccent

    static let textPrimary = SquashGColors.textPrimary
    static let textSecondary = SquashGColors.textSecondary

    static let cardCornerRadius: CGFloat = 20
    static let buttonCornerRadius: CGFloat = 18
    static let buttonBorderWidth: CGFloat = 2.0
}

// Color hex initializer
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - View Modifiers

// Card style matching spec
struct SquashGCardModifier: ViewModifier {
    var glowColor: Color = SquashGColors.neonCyan
    var cornerRadius: CGFloat = AppTheme.cardCornerRadius

    func body(content: Content) -> some View {
        content
            .padding(0)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(SquashGColors.cardDark)
            )
            .cornerRadius(cornerRadius)
            // inner subtle dark shadow for depth
            .shadow(color: Color.black.opacity(0.4), radius: 8, x: 0, y: -2)
            // outer neon glow
            .shadow(color: glowColor.opacity(0.12), radius: 10, x: 0, y: 4)
    }
}

// Small button neon modifier (steppers / minor CTAs)
struct SquashGNeonButtonModifier: ViewModifier {
    var borderColor: Color = SquashGColors.neonCyan
    var isPressed: Bool = false
    var isEnabled: Bool = true

    func body(content: Content) -> some View {
        content
            .padding(.vertical, 10)
            .padding(.horizontal, 14)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.buttonCornerRadius, style: .continuous)
                    .fill(isEnabled ? Color.black.opacity(0.15) : Color.black.opacity(0.08))
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.buttonCornerRadius, style: .continuous)
                    .stroke(borderColor.opacity(isEnabled ? 0.12 : 0.06), lineWidth: 1)
            )
            .shadow(color: borderColor.opacity(isPressed ? 0.4 : 0.12), radius: isPressed ? 8 : 4, x: 0, y: isPressed ? 2 : 4)
            .scaleEffect(isPressed ? 0.985 : 1.0)
            .animation(.easeInOut(duration: 0.12), value: isPressed)
    }
}

// Primary CTA style (Start Set) per spec
struct SquashGPrimaryCTAStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.headline.bold())
            .foregroundColor(SquashGColors.neonPink)
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.buttonCornerRadius, style: .continuous)
                    .fill(SquashGColors.neonPink.opacity(0.15))
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.buttonCornerRadius, style: .continuous)
                    .stroke(
                        LinearGradient(colors: [SquashGColors.neonPink, SquashGColors.neonCyan], startPoint: .leading, endPoint: .trailing),
                        lineWidth: 2
                    )
            )
            .shadow(color: SquashGColors.neonPink.opacity(0.4), radius: 12, x: 0, y: 6)
    }
}

// MARK: - View Extensions
extension View {
    func squashGCard(glowColor: Color = SquashGColors.neonCyan, cornerRadius: CGFloat = AppTheme.cardCornerRadius) -> some View {
        modifier(SquashGCardModifier(glowColor: glowColor, cornerRadius: cornerRadius))
    }

    func squashGNeonButton(borderColor: Color = SquashGColors.neonCyan, isPressed: Bool = false, isEnabled: Bool = true) -> some View {
        modifier(SquashGNeonButtonModifier(borderColor: borderColor, isPressed: isPressed, isEnabled: isEnabled))
    }

    func primaryCTA() -> some View {
        modifier(SquashGPrimaryCTAStyle())
    }
}

// Centered nav title with a subtle whitish gradient to improve contrast on dark backgrounds
extension View {
    func centeredNavTitle(_ title: String) -> some View {
        self.toolbar {
            ToolbarItem(placement: .principal) {
                Text(title)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.white.opacity(0.95), Color.white.opacity(0.65)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            }
        }
    }
}
