import Foundation

// Элемент корзины - товар с количеством
struct CartItem: Identifiable {
    // Уникальный ID элемента корзины
    let id: UUID
    // Товар который добавлен в корзину
    let product: Product
    // Количество этого товара
    var quantity: Int
    
    init(product: Product, quantity: Int = 1) {
        self.id = UUID()
        self.product = product
        self.quantity = quantity
    }
    
    // Общая стоимость этого товара (цена * количество)
    var totalPrice: Double {
        product.price * Double(quantity)
    }
    
    // Форматированная общая стоимость
    var formattedTotalPrice: String {
        String(format: "US$%.2f", totalPrice)
    }
}

