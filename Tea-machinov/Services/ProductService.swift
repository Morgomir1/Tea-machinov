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
    
    init() {
        Task {
            await loadProducts()
        }
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
            isLoading = false
        } catch {
            self.error = error
            isLoading = false
            print("Error loading products: \(error)")
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
            products[index].is_liked.toggle()
        }
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

