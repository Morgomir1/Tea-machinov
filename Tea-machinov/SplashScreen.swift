import SwiftUI

// Экран заставки при запуске приложения
struct SplashScreen: View {
    // Флаг для анимации появления логотипа
    @State private var isAnimating = false
    // Колбэк который вызывается когда заставка закончилась
    var onFinish: () -> Void
    
    var body: some View {
        ZStack {
            // Черный фон на весь экран
            Color.black
                .edgesIgnoringSafeArea(.all)
            
            // Логотип Nike по центру
            Image("nike_icon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 120, height: 120)
                .colorMultiply(.white)
                // Плавно появляется и увеличивается
                .opacity(isAnimating ? 1.0 : 0.0)
                .scaleEffect(isAnimating ? 1.0 : 0.8)
        }
        .onAppear {
            // Запускаем анимацию появления
            withAnimation(.easeInOut(duration: 0.8)) {
                isAnimating = true
            }
            
            // Через 2.5 секунды переходим на следующий экран
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                onFinish()
            }
        }
    }
}

#Preview {
    SplashScreen(onFinish: {})
}

