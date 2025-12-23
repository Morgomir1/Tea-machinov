//
//  FavoritesService.swift
//  Tea-machinov
//
//  Created by user on 04.12.2025.
//

import Foundation
import Combine

class FavoritesService: ObservableObject {
    @Published var favoriteProductIds: Set<UUID> = []
    
    init() {
        loadFavorites()
    }
    
    // Добавить товар в избранное
    func addToFavorites(_ productId: UUID) {
        favoriteProductIds.insert(productId)
        saveFavorites()
    }
    
    // Удалить товар из избранного
    func removeFromFavorites(_ productId: UUID) {
        favoriteProductIds.remove(productId)
        saveFavorites()
    }
    
    // Переключить состояние избранного
    func toggleFavorite(_ productId: UUID) {
        if favoriteProductIds.contains(productId) {
            removeFromFavorites(productId)
        } else {
            addToFavorites(productId)
        }
    }
    
    // Проверить, находится ли товар в избранном
    func isFavorite(_ productId: UUID) -> Bool {
        favoriteProductIds.contains(productId)
    }
    
    // Получить количество избранных товаров
    var favoritesCount: Int {
        favoriteProductIds.count
    }
    
    // Сохранить избранное в UserDefaults
    private func saveFavorites() {
        let idsArray = Array(favoriteProductIds).map { $0.uuidString }
        UserDefaults.standard.set(idsArray, forKey: "favoriteProductIds")
    }
    
    // Загрузить избранное из UserDefaults
    private func loadFavorites() {
        if let idsArray = UserDefaults.standard.array(forKey: "favoriteProductIds") as? [String] {
            favoriteProductIds = Set(idsArray.compactMap { UUID(uuidString: $0) })
        }
    }
    
    // Очистить все избранное
    func clearFavorites() {
        favoriteProductIds.removeAll()
        saveFavorites()
    }
}

