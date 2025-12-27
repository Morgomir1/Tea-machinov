import Foundation

// Утилиты для фильтрации товаров по категориям
struct ProductFilterUtils {
    // Проверяем, подходит ли товар под категорию (Men, Women, Kids)
    static func matchesCategory(product: Product, category: String) -> Bool {
        let productName = product.product_name.lowercased()
        let brand = product.brand.lowercased()
        let combined = "\(productName) \(brand)".lowercased()
        
        switch category {
        case "Men":
            return combined.contains("men") || 
                   combined.contains("men's") ||
                   productName.contains("men") ||
                   productName.contains("Men")
        case "Women":
            return combined.contains("women") || 
                   combined.contains("women's") ||
                   productName.contains("women") ||
                   productName.contains("Women")
        case "Kids":
            return combined.contains("kids") || 
                   combined.contains("kid's") ||
                   combined.contains("children") ||
                   productName.contains("kids") ||
                   productName.contains("Kids")
        default:
            return true
        }
    }
    
    // Проверяем, подходит ли товар под подкатегорию (Socks, Accessories, Player, Training)
    static func matchesSubCategory(product: Product, subCategory: String) -> Bool {
        let productName = product.product_name.lowercased()
        let brand = product.brand.lowercased()
        let combined = "\(productName) \(brand)".lowercased()
        
        switch subCategory {
        case "Socks":
            return combined.contains("sock") || 
                   combined.contains("носки") ||
                   productName.contains("sock")
        case "Accessories & Equipment":
            return combined.contains("backpack") ||
                   combined.contains("bag") ||
                   combined.contains("equipment") ||
                   combined.contains("accessories") ||
                   combined.contains("аксессуар") ||
                   combined.contains("рюкзак")
        case "Player":
            return combined.contains("player") ||
                   combined.contains("basketball") ||
                   combined.contains("jordan") ||
                   combined.contains("игрок") ||
                   brand.contains("jordan")
        case "Training":
            return combined.contains("training") ||
                   combined.contains("dri-fit") ||
                   combined.contains("therma") ||
                   combined.contains("трениров") ||
                   productName.contains("training") ||
                   productName.contains("Training")
        default:
            return true
        }
    }
}
