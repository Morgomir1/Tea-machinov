import Foundation
import Combine

// Сервис для работы с корзиной покупок
class CartService: ObservableObject {
    // Товары в корзине
    @Published var items: [CartItem] = []
    
    // Общее количество товаров (суммируем quantity всех товаров)
    var totalItems: Int {
        items.reduce(0) { $0 + $1.quantity }
    }
    
    // Общая стоимость корзины
    var totalPrice: Double {
        items.reduce(0) { $0 + $1.totalPrice }
    }
    
    // Форматированная цена для отображения
    var formattedTotalPrice: String {
        String(format: "US$%.2f", totalPrice)
    }
    
    // Добавляем товар в корзину (или увеличиваем количество если уже есть)
    func addProduct(_ product: Product, quantity: Int = 1) {
        if let index = items.firstIndex(where: { $0.product.id == product.id }) {
            // Товар уже в корзине - увеличиваем количество
            items[index].quantity += quantity
        } else {
            // Новый товар - добавляем
            items.append(CartItem(product: product, quantity: quantity))
        }
    }
    
    // Удаляем товар из корзины
    func removeProduct(_ product: Product) {
        items.removeAll { $0.product.id == product.id }
    }
    
    // Обновляем количество товара
    func updateQuantity(for product: Product, quantity: Int) {
        if let index = items.firstIndex(where: { $0.product.id == product.id }) {
            if quantity <= 0 {
                // Если количество 0 или меньше - удаляем товар
                items.remove(at: index)
            } else {
                // Иначе обновляем количество
                items[index].quantity = quantity
            }
        }
    }
    
    // Очищаем всю корзину
    func clearCart() {
        items.removeAll()
    }
    
    // Проверяем, есть ли товар в корзине
    func isProductInCart(_ product: Product) -> Bool {
        items.contains { $0.product.id == product.id }
    }
}

