import SwiftUI

// Главный контейнер для навигации между экранами
struct ContentView: View {
    // Текущий экран, который показываем пользователю
    @State private var currentScreen: AppScreen = .splash
    
    // Все возможные экраны в приложении
    enum AppScreen {
        case splash, main, onboarding, tabs, signIn
    }
    
    var body: some View {
        // Переключаемся между экранами в зависимости от состояния
        switch currentScreen {
        case .splash:
            // Показываем splash screen при запуске
            SplashScreen(onFinish: {
                currentScreen = .main
            })
        case .main:
            // Главный экран с кнопками входа
            MainScreen(
                goToOnboarding: {
                    currentScreen = .onboarding
                },
                goToSignIn: {
                    currentScreen = .signIn
                }
            )
        case .signIn:
            // Экран авторизации с вводом email
            EmailAuthView(
                onSuccess: {
                    currentScreen = .tabs
                },
                onCancel: {
                    currentScreen = .main
                }
            )
        case .onboarding:
            // Экран онбординга для выбора интересов
            OnboardingScreen(goToTabs: {
                currentScreen = .tabs
            })
        case .tabs:
            // Основной экран приложения с табами
            TabsScreen(goToOnboarding: {
                currentScreen = .onboarding
            })
        }
    }
}
