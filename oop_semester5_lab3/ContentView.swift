//
//  ContentView.swift
//  oop_semester5_lab3
//
//  Created by Вікторія Білик on 10.11.2024.
//


import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.black // Встановлюємо фоновий колір
                .ignoresSafeArea() // Заповнюємо весь екран, включаючи області за межами safe area
            
            VStack(alignment: .leading) {
                Text("Calories: ")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.red)
                
                HStack(alignment: .top) {
                    Text("Steps: ")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                    Spacer()
                    Text("Distance: ")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                }
                Spacer() // Додаємо простір унизу, щоб вміст був вгорі
            }
            .padding(.horizontal, 30)
            .padding(.top, 30)
        }
    }
}

#Preview {
    ContentView()
}


