import SwiftUI

// Карточка товара для горизонтального списка рекомендаций (меньше размером)
struct RecommendedProductCard: View {
    let product: Product
    // Колбэк при нажатии на избранное
    let onLikeToggle: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Изображение товара
            AsyncImage(url: URL(string: product.image_url)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                // Плейсхолдер пока загружается
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .overlay(
                        ProgressView()
                    )
            }
            .frame(width: 150, height: 150)
            .clipped()
            .cornerRadius(12)
            .overlay(
                // Кнопка избранного поверх изображения
                Button(action: onLikeToggle) {
                    Image(systemName: product.is_liked ? "heart.fill" : "heart")
                        .foregroundColor(product.is_liked ? .red : .white)
                        .font(.system(size: 14))
                        .padding(6)
                        .background(Color.black.opacity(0.1))
                        .clipShape(Circle())
                }
                .padding(8),
                alignment: .topTrailing
            )
            
            // Бренд
            Text(product.brand)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.primary)
                .lineLimit(1)
            
            // Название товара
            Text(product.product_name)
                .font(.system(size: 11))
                .foregroundColor(.secondary)
                .lineLimit(2)
            
            // Цена
            Text(product.formattedPrice)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.primary)
        }
        .frame(width: 150) // Фиксированная ширина для горизонтального списка
    }
}

