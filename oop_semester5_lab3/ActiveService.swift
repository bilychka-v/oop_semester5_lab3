import Foundation
import CoreMotion

class ActiveService: ObservableObject {
    private let pedometer = CMPedometer()
    
    @Published var numberOfSteps: Int? = 0
    @Published var distance: Double? = 0.0
    private var startDate: Date? = nil
    
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
        
        // Запит на історичні дані (1 година до поточного часу)
        pedometer.queryPedometerData(from: now.addingTimeInterval(-3600), to: now) { [weak self] data, error in
            guard let self = self, let data = data, error == nil else {
                print("Failed to query pedometer data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            DispatchQueue.main.async {
                self.numberOfSteps = data.numberOfSteps.intValue
                self.distance = data.distance?.doubleValue ?? 0.0
                print("Queried data: Steps = \(self.numberOfSteps ?? 0), Distance = \(self.distance ?? 0.0)")
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
                print("Live data: Steps = \(self.numberOfSteps ?? 0), Distance = \(self.distance ?? 0.0)")
            }
        }
    }

    
    func checkAuthStatus() -> Bool {
        let status = CMPedometer.authorizationStatus()
        switch status {
        case .authorized:
            print("Authorization status: authorized")
            return true
        case .denied:
            print("Authorization status: denied")
        case .restricted:
            print("Authorization status: restricted")
        case .notDetermined:
            print("Authorization status: not determined")
        @unknown default:
            print("Authorization status: unknown")
        }
        return false
    }

    
    func stopMonitoring() {
        pedometer.stopUpdates()
        print("Stopped monitoring pedometer data.")
    }
}
