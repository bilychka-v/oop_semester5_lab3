import Foundation
import CoreMotion

class ActiveService: ObservableObject {
    private let pedometer = CMPedometer()
    
    @Published var numberOfSteps: Int? = 0
    @Published var distance: Double? = 0.0
    @Published var burnedCalories: Double? = 0.0
    
//    private let userWeight: Double = 70.0 
    
    func startMonitoring() {
        guard CMPedometer.isStepCountingAvailable() else {
            print("Step counting is not available on this device.")
            return
        }
        
        guard CMPedometer.authorizationStatus() == .authorized else {
            print("Authorization not granted. Enable Motion & Fitness tracking in Settings.")
            return
        }
        
        let now = Date()
        
        // Запит на історичні дані
        pedometer.queryPedometerData(from: now.addingTimeInterval(-3600), to: now) {
            [weak self] data, error in
            guard let self = self, let data = data, error == nil else {
                print("Failed to query pedometer data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            DispatchQueue.main.async {
                self.numberOfSteps = data.numberOfSteps.intValue
                self.distance = data.distance?.doubleValue ?? 0.0
                self.burnedCalories = self.updateCalories(steps: self.numberOfSteps ?? 0, distance: self.distance ?? 0.0)
            }
        }
        
        // Старт моніторингу
        pedometer.startUpdates(from: now) { [weak self] data, error in
            guard let self = self, let data = data, error == nil else {
                print("Failed to start pedometer updates: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            DispatchQueue.main.async {
                self.numberOfSteps = data.numberOfSteps.intValue
                self.distance = data.distance?.doubleValue ?? 0.0
                self.burnedCalories = self.updateCalories(steps: self.numberOfSteps ?? 0, distance: self.distance ?? 0.0)
            }
        }
    }
    
    private func updateCalories(steps: Int, distance: Double) -> Double {
        return Double(steps) * 0.05 + (distance / 1000.0) * 50.0
    }
    
    func checkAuthStatus() -> Bool {
        let status = CMPedometer.authorizationStatus()
        switch status {
        case .authorized:
            return true
        case .denied, .restricted, .notDetermined:
            return false
        @unknown default:
            return false
        }
    }
    
    func stopMonitoring() {
        pedometer.stopUpdates()
    }
}
