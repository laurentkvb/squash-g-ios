import Foundation
import SwiftUI

struct OnboardingPageModel: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let icon: AnyView
    let backgroundGlow: Color
}
