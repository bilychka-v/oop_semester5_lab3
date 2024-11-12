import SwiftUI

struct ContentView: View {
    @StateObject private var activeService = ActiveService()
    
    @State private var steps: Int = 0
    @State private var distance: Double = 0.0
    @State private var calories: Double = 0.0
    
    private let caloryGoal: Double = 500.0
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Health Tracker")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                HStack {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.pink)
                    Text("Calories:")
                        .font(.title2)
                        .foregroundColor(.white)
                    Spacer()
                    Text("\(Int(calories)) kcal")
                        .font(.title2)
                        .foregroundColor(.pink)
                }
                .padding()
                .background(Color.gray.opacity(0.3))
                .cornerRadius(10)
                
                ProgressCircle(progress: calories / caloryGoal, color: .pink)
                    .frame(width: 150, height: 150)
                    .padding(.vertical, 20)
                
                HStack {
                    Image(systemName: "figure.walk")
                        .foregroundColor(.blue)
                    Text("Steps:")
                        .font(.title2)
                        .foregroundColor(.white)
                    Spacer()
                    Text("\(steps)")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
                .padding()
                .background(Color.gray.opacity(0.3))
                .cornerRadius(10)
                
                HStack {
                    Image(systemName: "location")
                        .foregroundColor(.green)
                    Text("Distance:")
                        .font(.title2)
                        .foregroundColor(.white)
                    Spacer()
                    Text(String(format: "%.2f km", distance))
                        .font(.title2)
                        .foregroundColor(.green)
                }
                .padding()
                .background(Color.gray.opacity(0.3))
                .cornerRadius(10)
                
                Spacer()
            }
            .padding(.top, 50)
            .padding(.horizontal, 20)
        }
        .onAppear(perform: startMonitoring)
        .onDisappear(perform: stopMonitoring)
        .onReceive(activeService.$numberOfSteps) { steps in
            self.steps = steps ?? 0
            print("Steps updated: \(steps ?? 0)")
        }
        .onReceive(activeService.$distance) { distance in
            self.distance = (distance ?? 0) / 1000.0
            print("Distance updated: \(distance ?? 0.0)")
        }
        .onReceive(activeService.$burnedCalories) { calories in
            self.calories = calories ?? 0.0
            print("Calories updated: \(calories ?? 0.0)")
        }
    }
    
    private func startMonitoring() {
        let authStatus = activeService.checkAuthStatus()
        if authStatus {
            activeService.startMonitoring()
        }
    }
    
    private func stopMonitoring() {
        activeService.stopMonitoring()
    }
}

struct ProgressCircle: View {
    var progress: Double
    var color: Color

    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 30)
                .foregroundColor(color.opacity(0.3))
            
            Circle()
                .trim(from: 0.0, to: CGFloat(progress))
                .stroke(color, style: StrokeStyle(lineWidth: 30, lineCap: .round))
                .rotationEffect(.degrees(-90))
            
            Text("\(Int(progress * 100))%")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)

        }
    }
}

#Preview {
    ContentView()
}
