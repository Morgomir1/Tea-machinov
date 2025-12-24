//
//  ProductService.swift
//  Tea-machinov
//
//  Created by user on 04.12.2025.
//

import Foundation
import Combine

class ProductService: ObservableObject {
    @Published var products: [Product] = []
    @Published var isLoading: Bool = false
    @Published var error: Error?
    
    private var favoritesService: FavoritesService?
    private var cancellables = Set<AnyCancellable>()
    
    init(favoritesService: FavoritesService? = nil) {
        self.favoritesService = favoritesService
        Task {
            await loadProducts()
        }
    }
    
    func setFavoritesService(_ service: FavoritesService) {
        // Отменяем предыдущую подписку, если была
        cancellables.removeAll()
        
        self.favoritesService = service
        
        // Синхронизируем состояние избранного при установке сервиса
        syncFavoritesState()
        
        // Подписываемся на изменения избранного для автоматической синхронизации
        service.$favoriteProductIds
            .dropFirst() // Пропускаем первое значение (текущее состояние)
            .sink { [weak self] _ in
                self?.syncFavoritesState()
            }
            .store(in: &cancellables)
    }
    
    @MainActor
    func loadProducts() async {
        isLoading = true
        error = nil
        
        do {
            guard let url = Bundle.main.url(forResource: "products", withExtension: "json") else {
                throw ProductServiceError.fileNotFound
            }
            
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            products = try decoder.decode([Product].self, from: data)
            
            // Синхронизируем состояние избранного после загрузки
            syncFavoritesState()
            
            isLoading = false
        } catch {
            self.error = error
            isLoading = false
            print("Error loading products: \(error)")
        }
    }
    
    // Синхронизировать состояние is_liked с FavoritesService
    private func syncFavoritesState() {
        guard let favoritesService = favoritesService else { return }
        
        for index in products.indices {
            let productId = products[index].id
            products[index].is_liked = favoritesService.isFavorite(productId)
        }
    }
    
    func getBestsellers() -> [Product] {
        products.filter { $0.is_bestseller }
    }
    
    func getRecommendedProducts() -> [Product] {
        // Возвращаем первые несколько товаров как рекомендации
        Array(products.prefix(4))
    }
    
    func getNewProducts() -> [Product] {
        // Возвращаем последние товары как новые (предполагаем, что последние добавленные товары - это новые)
        // Берем последние 20 товаров, которые не являются бестселлерами
        let nonBestsellers = products.filter { !$0.is_bestseller }
        if nonBestsellers.count > 20 {
            return Array(nonBestsellers.suffix(20))
        }
        return nonBestsellers
    }
    
    func getProductsByCategory(_ category: String) -> [Product] {
        // Пока возвращаем все товары, так как в JSON нет категорий
        // В будущем можно добавить фильтрацию по категориям
        products
    }
    
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
    
    func toggleLike(for product: Product) {
        if let index = products.firstIndex(where: { $0.id == product.id }) {
            let newState = !products[index].is_liked
            products[index].is_liked = newState
            
            // Синхронизируем с FavoritesService
            if let favoritesService = favoritesService {
                if newState {
                    favoritesService.addToFavorites(product.id)
                } else {
                    favoritesService.removeFromFavorites(product.id)
                }
            }
        }
    }
    
    // Получить избранные товары
    func getFavoriteProducts() -> [Product] {
        guard let favoritesService = favoritesService else {
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

