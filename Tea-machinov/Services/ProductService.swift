import Foundation
import Combine

// Сервис для работы с товарами - загрузка, поиск, фильтрация
class ProductService: ObservableObject {
    // Все товары в приложении
    @Published var products: [Product] = []
    // Идет ли загрузка товаров
    @Published var isLoading: Bool = false
    // Ошибка при загрузке (если была)
    @Published var error: Error?
    
    // Ссылка на сервис избранного для синхронизации
    private var favoritesService: FavoritesService?
    // Для отмены подписок на изменения
    private var cancellables = Set<AnyCancellable>()
    
    init(favoritesService: FavoritesService? = nil) {
        self.favoritesService = favoritesService
        // Загружаем товары асинхронно при создании
        Task {
            await loadProducts()
        }
    }
    
    // Устанавливаем сервис избранного и подписываемся на его изменения
    func setFavoritesService(_ service: FavoritesService) {
        cancellables.removeAll()
        
        self.favoritesService = service
        
        // Синхронизируем состояние сразу
        syncFavoritesState()
        
        // Подписываемся на изменения избранного, чтобы обновлять товары автоматически
        service.$favoriteProductIds
            .dropFirst() // Пропускаем первое значение
            .sink { [weak self] _ in
                self?.syncFavoritesState()
            }
            .store(in: &cancellables)
    }
    
    // Загружаем товары из JSON файла
    @MainActor
    func loadProducts() async {
        isLoading = true
        error = nil
        
        do {
            // Ищем файл products.json в Bundle
            guard let url = Bundle.main.url(forResource: "products", withExtension: "json") else {
                throw ProductServiceError.fileNotFound
            }
            
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            products = try decoder.decode([Product].self, from: data)
            
            // После загрузки синхронизируем с избранным
            syncFavoritesState()
            
            isLoading = false
        } catch {
            self.error = error
            isLoading = false
            print("Error loading products: \(error)")
        }
    }
    
    // Синхронизируем флаг is_liked у товаров с сервисом избранного
    private func syncFavoritesState() {
        guard let favoritesService = favoritesService else { return }
        
        // Проходим по всем товарам и обновляем статус избранного
        for index in products.indices {
            let productId = products[index].id
            products[index].is_liked = favoritesService.isFavorite(productId)
        }
    }
    
    // Получаем только бестселлеры
    func getBestsellers() -> [Product] {
        products.filter { $0.is_bestseller }
    }
    
    // Рекомендуемые товары - просто первые 4 из списка
    func getRecommendedProducts() -> [Product] {
        Array(products.prefix(4))
    }
    
    // Новые товары - последние 20, которые не бестселлеры
    func getNewProducts() -> [Product] {
        let nonBestsellers = products.filter { !$0.is_bestseller }
        if nonBestsellers.count > 20 {
            return Array(nonBestsellers.suffix(20))
        }
        return nonBestsellers
    }
    
    // Товары по категории (пока возвращаем все, т.к. в JSON нет категорий)
    func getProductsByCategory(_ category: String) -> [Product] {
        products
    }
    
    // Поиск товаров по названию или бренду
    func searchProducts(query: String) -> [Product] {
        guard !query.isEmpty else {
            return []
        }
        
        let lowercasedQuery = query.lowercased()
        return products.filter { product in
            product.brand.lowercased().contains(lowercasedQuery) ||
            product.product_name.lowercased().contains(lowercasedQuery)
        }
    }
    
    // Переключаем лайк у товара
    func toggleLike(for product: Product) {
        if let index = products.firstIndex(where: { $0.id == product.id }) {
            let newState = !products[index].is_liked
            products[index].is_liked = newState
            
            // Обновляем в сервисе избранного тоже
            if let favoritesService = favoritesService {
                if newState {
                    favoritesService.addToFavorites(product.id)
                } else {
                    favoritesService.removeFromFavorites(product.id)
                }
            }
        }
    }
    
    // Получаем все избранные товары
    func getFavoriteProducts() -> [Product] {
        guard let favoritesService = favoritesService else {
            // Если сервиса нет, фильтруем по локальному флагу
            return products.filter { $0.is_liked }
        }
        return products.filter { favoritesService.isFavorite($0.id) }
    }
}

enum ProductServiceError: LocalizedError {
    case fileNotFound
    
    var errorDescription: String? {
        switch self {
        case .fileNotFound:
            return "Файл products.json не найден в Bundle"
        }
    }
}

