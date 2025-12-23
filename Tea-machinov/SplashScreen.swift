//
//  SplashScreen.swift
//  Tea-machinov
//
//  Created by user on 04.12.2025.
//

import SwiftUI

struct SplashScreen: View {
    @State private var isAnimating = false
    var onFinish: () -> Void
    
    var body: some View {
        ZStack {
            // Черный фон
            Color.black
                .edgesIgnoringSafeArea(.all)
            
            // Логотип Nike по центру
            Image("nike_icon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 120, height: 120)
                .colorMultiply(.white)
                .opacity(isAnimating ? 1.0 : 0.0)
                .scaleEffect(isAnimating ? 1.0 : 0.8)
        }
        .onAppear {
            // Анимация появления
            withAnimation(.easeInOut(duration: 0.8)) {
                isAnimating = true
            }
            
            // Переход к следующему экрану через 2.5 секунды
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                onFinish()
            }
        }
    }
}

#Preview {
    SplashScreen(onFinish: {})
}

