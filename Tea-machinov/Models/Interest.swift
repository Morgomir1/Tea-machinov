import Foundation

// Интерес пользователя - категория товаров которая ему нравится
struct Interest: Identifiable, Hashable {
    // Уникальный ID интереса
    let id: UUID
    // Название интереса (например, "Running")
    let title: String
    // Имя изображения для отображения
    let imageName: String
    // Категория для фильтрации товаров
    let category: String
    
    init(id: UUID = UUID(), title: String, imageName: String, category: String) {
        self.id = id
        self.title = title
        self.imageName = imageName
        self.category = category
    }
}

