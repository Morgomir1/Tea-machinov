import Foundation
import Combine

// Сервис для управления интересами пользователя
class InterestService: ObservableObject {
    // Выбранные пользователем интересы
    @Published var selectedInterests: [Interest] = []
    
    // Все доступные интересы в приложении
    let availableInterests: [Interest] = [
        Interest(title: "Running", imageName: "muzhik1", category: "Running"),
        Interest(title: "Training", imageName: "crossovki", category: "Training"),
        Interest(title: "Basketball", imageName: "crossovki2", category: "Basketball"),
        Interest(title: "Shoes", imageName: "crossovki3", category: "Shoes"),
        Interest(title: "Apparel", imageName: "crossovki4", category: "Apparel"),
        Interest(title: "Accessories", imageName: "food", category: "Accessories")
    ]
    
    init() {
        // По умолчанию выбираем первые 3 интереса
        selectedInterests = Array(availableInterests.prefix(3))
    }
    
    // Добавляем интерес (если его еще нет)
    func addInterest(_ interest: Interest) {
        if !selectedInterests.contains(where: { $0.id == interest.id }) {
            selectedInterests.append(interest)
        }
    }
    
    // Удаляем интерес
    func removeInterest(_ interest: Interest) {
        selectedInterests.removeAll { $0.id == interest.id }
    }
    
    // Получаем товары по интересу - фильтруем по названию, бренду или категории
    func getProductsByInterest(_ interest: Interest, from products: [Product]) -> [Product] {
        let interestCategory = interest.category.lowercased()
        return products.filter { product in
            let productName = product.product_name.lowercased()
            let brand = product.brand.lowercased()
            let category = product.category?.lowercased() ?? ""
            // Объединяем все в одну строку для поиска
            let combined = "\(productName) \(brand) \(category)".lowercased()
            
            // Ищем совпадения в любом из полей
            return combined.contains(interestCategory) ||
                   productName.contains(interestCategory) ||
                   brand.contains(interestCategory) ||
                   category.contains(interestCategory)
        }
    }
}

