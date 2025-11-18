
import Foundation
import Combine

class TimerService: ObservableObject {
    @Published var elapsedTime: TimeInterval = 0
    
    private var timer: Timer?
    private var startDate: Date?
    
    func start(from date: Date = Date()) {
        startDate = date
        elapsedTime = Date().timeIntervalSince(date)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self, let startDate = self.startDate else { return }
            self.elapsedTime = Date().timeIntervalSince(startDate)
        }
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
    }
    
    func reset() {
        stop()
        elapsedTime = 0
        startDate = nil
    }
    
    var formattedTime: String {
        let minutes = Int(elapsedTime) / 60
        let seconds = Int(elapsedTime) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
