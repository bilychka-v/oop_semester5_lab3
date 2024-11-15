import Foundation
import CoreMotion
import os

class ActiveService: ObservableObject {
    private let pedometer = CMPedometer()
    private let logger = Logger(subsystem: "com.example.HealthTracker", category: "ActiveService")
    
    @Published var numberOfSteps: Int? = 0
    @Published var distance: Double? = 0.0
    @Published var burnedCalories: Double? = 0.0
    
//    private let userWeight: Double = 40.0

    func startMonitoring() {
        guard CMPedometer.isStepCountingAvailable() else {
            logger.error("Step counting is not available on this device.")
            return
        }
        
        guard CMPedometer.authorizationStatus() == .authorized else {
            logger.warning("Authorization not granted. Enable Motion & Fitness tracking in Settings.")
            return
        }
        
        let now = Date()
        
        // Запит на історичні дані
        pedometer.queryPedometerData(from: now.addingTimeInterval(-3600), to: now) { [weak self] data, error in
            guard let self = self, let data = data, error == nil else {
                self?.logger.error("Failed to query pedometer data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            DispatchQueue.main.async {
                self.numberOfSteps = data.numberOfSteps.intValue
                self.distance = data.distance?.doubleValue ?? 0.0
                self.burnedCalories = self.updateCalories(steps: self.numberOfSteps ?? 0, distance: self.distance ?? 0.0)
                
                self.logger.info("Historical data queried: Steps=\(self.numberOfSteps ?? 0), Distance=\(self.distance ?? 0.0) meters, Calories=\(self.burnedCalories ?? 0.0) kcal")
            }
        }
        
        // Старт моніторингу
        pedometer.startUpdates(from: now) { [weak self] data, error in
            guard let self = self, let data = data, error == nil else {
                self?.logger.error("Failed to start pedometer updates: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            DispatchQueue.main.async {
                self.numberOfSteps = data.numberOfSteps.intValue
                self.distance = data.distance?.doubleValue ?? 0.0
                self.burnedCalories = self.updateCalories(steps: self.numberOfSteps ?? 0, distance: self.distance ?? 0.0)
                
                self.logger.info("Live data updated: Steps=\(self.numberOfSteps ?? 0), Distance=\(self.distance ?? 0.0) meters, Calories=\(self.burnedCalories ?? 0.0) kcal")
            }
        }
    }
    
    private func updateCalories(steps: Int, distance: Double) -> Double {
        let calories = Double(steps) * 0.05 + (distance / 1000.0) * 50.0
        logger.debug("Calories calculated: \(calories) kcal for \(steps) steps and \(distance) meters")
        return calories
    }
    
    func checkAuthStatus() -> Bool {
        let status = CMPedometer.authorizationStatus()
        switch status {
        case .authorized:
            logger.info("Authorization status: Authorized")
            return true
        case .denied:
            logger.warning("Authorization status: Denied")
            return false
        case .restricted:
            logger.warning("Authorization status: Restricted")
            return false
        case .notDetermined:
            logger.info("Authorization status: Not determined")
            return false
        @unknown default:
            logger.error("Authorization status: Unknown status")
            return false
        }
    }
    
    func stopMonitoring() {
        pedometer.stopUpdates()
        logger.info("Stopped monitoring pedometer data.")
    }
}
