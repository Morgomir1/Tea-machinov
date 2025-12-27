import SwiftUI

// Главный контейнер для навигации между экранами
struct ContentView: View {
    // Текущий экран, который показываем пользователю
    @State private var currentScreen: AppScreen = .splash
    // Сервис авторизации - создаем один раз и передаем во все экраны
    @StateObject private var authService = AuthService()
    
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
                authService: authService,
                goToOnboarding: {
                    currentScreen = .onboarding
                },
                onSignInSuccess: {
                    currentScreen = .tabs
                }
            )
        case .signIn:
            // Экран авторизации с вводом email
            EmailAuthView(
                authService: authService,
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
            TabsScreen(
                authService: authService,
                goToOnboarding: {
                    currentScreen = .onboarding
                }
            )
        }
    }
}
