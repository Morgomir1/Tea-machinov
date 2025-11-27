//
//  ContentView 2.swift
//  Tea-machinov
//
//  Created by user on 27.11.2025.
//


import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            // Фон
            Image("background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                // Плашка с контентом
                VStack(spacing: 20) {
                    Text("Nike App")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    Text("Bringing Nike Members the best products, inspiration and stories in sport.")
                        .font(.body)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Button("Join Us") {
                        // Действие для Join Us
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.black)
                    .cornerRadius(25)
                    
                    Button("Sign In") {
                        // Действие для Sign In
                    }
                    .font(.headline)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.black, lineWidth: 2)
                    )
                }
                .padding(30)
                .background(Color.white)
                .cornerRadius(16)
                .shadow(radius: 10)
                .padding(.horizontal, 20)
                
                Spacer()
            }
            
            // Bottom Sheet
            VStack {
                Spacer()
                BottomSheetView()
            }
        }
        .statusBar(hidden: false)
    }
}

struct BottomSheetView: View {
    var body: some View {
        VStack {
            // Handle для bottom sheet
            RoundedRectangle(cornerRadius: 2)
                .frame(width: 40, height: 4)
                .foregroundColor(.gray)
                .padding(.top, 8)
            
            Spacer()
            
            // Здесь можно добавить контент для bottom sheet
            Text("Bottom Sheet Content")
                .foregroundColor(.gray)
            
            Spacer()
        }
        .frame(height: 200)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(20, corners: [.topLeft, .topRight])
        .shadow(radius: 5)
    }
}

// Extension для скругления только определенных углов
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}