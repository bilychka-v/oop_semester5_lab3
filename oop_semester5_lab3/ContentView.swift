import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack{
            Color.black.ignoresSafeArea()
            VStack(spacing:20){
                Text("Menu")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                HStack{
                    Image(systemName: "flame.fill")
                        .foregroundColor(.pink)
                    Text("Calories: ")
                        .font(.title2)
                        .foregroundColor(Color.white)
                    Spacer()
                    Text("0 kcal")
                        .font(.title2)
                        .foregroundColor(Color.pink)
                }
                .padding()
                .background(Color.gray.opacity(0.3))
                .cornerRadius(10)
                
                ProgressCircle(progress: 0.5,color: .pink)
                    .frame(width: 100, height: 100) // Adjust the size as needed
                    .padding(.top, 10)
                
                HStack{
                    Image(systemName: "figure.walk")
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    Text("Steps: ")
                        .font(.title2)
                        .foregroundColor(Color.white)
                    Spacer()
                    Text("0")
                        .font(.title2)
                        .foregroundColor(Color.blue)
                }
                .padding()
                .background(Color.gray.opacity(0.3))
                .cornerRadius(10)
                HStack{
                    Image(systemName: "location")
                        .foregroundColor(.green)
                    Text("Distance: ")
                        .font(.title2)
                        .foregroundColor(Color.white)
                    Spacer()
                    Text("0 km")
                        .font(.title2)
                        .foregroundColor(Color.green)
                }
                .padding()
                .background(Color.gray.opacity(0.3))
                .cornerRadius(10)
                Spacer()
            }
            .padding(.top, 50)
            .padding(.horizontal, 20)
        }
    }
}

struct ProgressCircle: View {
    var progress: Double
    var color: Color

    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20)
                .foregroundColor(color.opacity(0.3))
            
            Circle()
                .trim(from: 0.0, to: CGFloat(progress))
                .stroke(color, lineWidth: 20)
                .rotationEffect(.degrees(-45))
            
            Text("\(Int(progress * 100))%")
                .font(.caption)
                .foregroundColor(.white)
        }
    }
}

#Preview {
    ContentView()
}
