import Foundation

// Модель товара - основная структура данных для продуктов
struct Product: Codable, Identifiable {
    // Уникальный идентификатор товара (генерируется при декодировании)
    let id: UUID
    // Бренд товара (например, "Nike")
    let brand: String
    // Название товара
    let product_name: String
    // Цена в долларах
    let price: Double
    // Сколько товаров осталось в наличии
    let items_left: Int
    // URL изображения товара
    let image_url: String
    // В избранном ли товар (может меняться)
    var is_liked: Bool
    // Является ли товар бестселлером
    let is_bestseller: Bool
    // Категория товара (опционально)
    let category: String?
    // Описание товара (опционально)
    let description: String?
    
    // Ключи для декодирования из JSON
    enum CodingKeys: String, CodingKey {
        case brand
        case product_name
        case price
        case items_left
        case image_url
        case is_liked
        case is_bestseller
        case category
        case description
    }
    
    // Кастомный декодер - генерируем UUID при создании
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID() // Генерируем новый UUID для каждого товара
        self.brand = try container.decode(String.self, forKey: .brand)
        self.product_name = try container.decode(String.self, forKey: .product_name)
        self.price = try container.decode(Double.self, forKey: .price)
        self.items_left = try container.decode(Int.self, forKey: .items_left)
        self.image_url = try container.decode(String.self, forKey: .image_url)
        self.is_liked = try container.decode(Bool.self, forKey: .is_liked)
        self.is_bestseller = try container.decode(Bool.self, forKey: .is_bestseller)
        // Категория и описание могут отсутствовать в JSON
        self.category = try container.decodeIfPresent(String.self, forKey: .category)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
    }
    
    // Обычный инициализатор для создания товара вручную
    init(id: UUID = UUID(), brand: String, product_name: String, price: Double, items_left: Int, image_url: String, is_liked: Bool, is_bestseller: Bool, category: String? = nil, description: String? = nil) {
        self.id = id
        self.brand = brand
        self.product_name = product_name
        self.price = price
        self.items_left = items_left
        self.image_url = image_url
        self.is_liked = is_liked
        self.is_bestseller = is_bestseller
        self.category = category
        self.description = description
    }
    
    // Вычисляемое свойство - распродан ли товар
    var isSoldOut: Bool {
        items_left == 0
    }
    
    // Форматированная цена для отображения
    var formattedPrice: String {
        String(format: "US$%.2f", price)
    }
}

