
import UIKit
import Combine

class HapticService {
    static let shared = HapticService()
    
    private let lightImpact = UIImpactFeedbackGenerator(style: .light)
    private let mediumImpact = UIImpactFeedbackGenerator(style: .medium)
    private let heavyImpact = UIImpactFeedbackGenerator(style: .heavy)
    private let selectionFeedback = UISelectionFeedbackGenerator()
    private let notificationFeedback = UINotificationFeedbackGenerator()
    
    private init() {
        lightImpact.prepare()
        mediumImpact.prepare()
        heavyImpact.prepare()
    }
    
    func light() {
        lightImpact.impactOccurred()
        lightImpact.prepare()
    }
    
    func medium() {
        mediumImpact.impactOccurred()
        mediumImpact.prepare()
    }
    
    func heavy() {
        heavyImpact.impactOccurred()
        heavyImpact.prepare()
    }
    
    func selection() {
        selectionFeedback.selectionChanged()
    }
    
    func success() {
        notificationFeedback.notificationOccurred(.success)
    }
    
    func warning() {
        notificationFeedback.notificationOccurred(.warning)
    }
    
    func error() {
        notificationFeedback.notificationOccurred(.error)
    }
}
