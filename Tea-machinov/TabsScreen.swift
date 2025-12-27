import SwiftUI

// Главный экран с табами - основная навигация приложения
struct TabsScreen: View {
    // Какой таб сейчас выбран (0 = Home, 1 = Shop, и т.д.)
    @State private var selectedTab = 0
    // Сервисы для работы с данными - создаем один раз и передаем дальше
    @StateObject private var cartService = CartService()
    @StateObject private var favoritesService = FavoritesService()
    @StateObject private var productService = ProductService()
    // Сервис авторизации
    @ObservedObject var authService: AuthService
    // Callback для перехода на экран авторизации
    var goToOnboarding: (() -> Void)?
    
    init(authService: AuthService, goToOnboarding: (() -> Void)? = nil) {
        self.authService = authService
        self.goToOnboarding = goToOnboarding
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Домашний экран
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                .tag(0)
            
            // Экран магазина с поиском
            ShopView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Shop")
                }
                .tag(1)
            
            // Избранные товары
            FavouritesView()
                .tabItem {
                    Image(systemName: "heart")
                    Text("Favourites")
                }
                .tag(2)
            
            // Корзина
            BagView()
                .tabItem {
                    Image(systemName: "bag")
                    Text("Bag")
                }
                .tag(3)
            
            // Профиль пользователя
            ProfileView(authService: authService, goToOnboarding: goToOnboarding)
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
                .tag(4)
        }
        .accentColor(.blue)
        .onAppear {
            // Настраиваем внешний вид таб-бара
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.systemBackground
            
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
            
            // Связываем сервисы между собой для синхронизации избранного
            productService.setFavoritesService(favoritesService)
        }
        // Передаем сервисы во все дочерние экраны
        .environmentObject(cartService)
        .environmentObject(favoritesService)
        .environmentObject(productService)
    }
}

#Preview {
    TabsScreen(authService: AuthService())
}