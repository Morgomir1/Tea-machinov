import Foundation
import Combine

// Сервис для управления избранными товарами
class FavoritesService: ObservableObject {
    // Множество ID избранных товаров (используем Set для быстрого поиска)
    @Published var favoriteProductIds: Set<UUID> = []
    
    init() {
        // При создании загружаем сохраненные избранные товары
        loadFavorites()
    }
    
    // Добавляем товар в избранное
    func addToFavorites(_ productId: UUID) {
        favoriteProductIds.insert(productId)
        saveFavorites() // Сохраняем сразу в UserDefaults
    }
    
    // Удаляем товар из избранного
    func removeFromFavorites(_ productId: UUID) {
        favoriteProductIds.remove(productId)
        saveFavorites()
    }
    
    // Переключаем состояние избранного (добавить/удалить)
    func toggleFavorite(_ productId: UUID) {
        if favoriteProductIds.contains(productId) {
            removeFromFavorites(productId)
        } else {
            addToFavorites(productId)
        }
    }
    
    // Проверяем, находится ли товар в избранном
    func isFavorite(_ productId: UUID) -> Bool {
        favoriteProductIds.contains(productId)
    }
    
    // Количество избранных товаров
    var favoritesCount: Int {
        favoriteProductIds.count
    }
    
    // Сохраняем избранное в UserDefaults
    private func saveFavorites() {
        // Конвертируем Set в массив строк для сохранения
        let idsArray = Array(favoriteProductIds).map { $0.uuidString }
        UserDefaults.standard.set(idsArray, forKey: "favoriteProductIds")
    }
    
    // Загружаем избранное из UserDefaults
    private func loadFavorites() {
        if let idsArray = UserDefaults.standard.array(forKey: "favoriteProductIds") as? [String] {
            // Конвертируем массив строк обратно в Set UUID
            favoriteProductIds = Set(idsArray.compactMap { UUID(uuidString: $0) })
        }
    }
    
    // Очищаем все избранное
    func clearFavorites() {
        favoriteProductIds.removeAll()
        saveFavorites()
    }
}

