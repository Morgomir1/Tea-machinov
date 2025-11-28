//
//  ContentView 2.swift
//  Tea-machinov
//
//  Created by user on 27.11.2025.
//

import SwiftUI

struct MainScreen: View {
    // Параметр для настройки размера шрифта
    @State private var titleFontSize: CGFloat = 30
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Фон
                Image("main_background")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                // Градиентное затемнение снизу
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.clear,
                        Color.black.opacity(1.0)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    
                    // Плашка с контентом (теперь прозрачная)
                    VStack(spacing: 0) {
                        Image("nike_icon")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 233, height: 132)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .offset(x: -69)
                        
                        Text("Nike App \nBringing Nike Member\nthe best products,\ninspiration and stories\nin sport.")
                            .font(.system(size: titleFontSize, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical)
                    }
                    .padding(10)
                    .background(Color.clear) // Прозрачный фо
                    .padding(.bottom, geometry.size.height * 0.25)
                }
                
                // Кнопки с позиционированием 15% от нижней границы
                VStack {
                    Spacer()
                    
                    HStack(spacing: 16) {
                        // Кнопка Join Us
                        Button("Join Us") {
                            // Действие для Join Us
                        }
                        .font(.headline)
                        .foregroundColor(.black)
                        .frame(width: 158, height: 50)
                        .background(Color.white)
                        .cornerRadius(50)
                        
                        // Кнопка Sign In
                        Button("Sign In") {
                            // Действие для Sign In
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 158, height: 50)
                        .background(Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(Color.white, lineWidth: 1)
                        )
                    }
                    .padding(.bottom, geometry.size.height * 0.15)
                }
                
                // Белый индикатор внизу экрана
                //BottomIndicatorView()
            }
        }
        // Status bar будет отображаться (это значение по умолчанию)
        .statusBar(hidden: false)
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

#Preview {
    MainScreen()
}
