import SwiftUI

// Строка товара в корзине с управлением количеством
struct CartItemRow: View {
    let item: CartItem
    // Колбэки для изменения количества и удаления
    let onQuantityChange: (Int) -> Void
    let onRemove: () -> Void
    // Локальное состояние количества (синхронизируется с item)
    @State private var quantity: Int
    
    init(item: CartItem, onQuantityChange: @escaping (Int) -> Void, onRemove: @escaping () -> Void) {
        self.item = item
        self.onQuantityChange = onQuantityChange
        self.onRemove = onRemove
        _quantity = State(initialValue: item.quantity)
    }
    
    var body: some View {
        HStack(spacing: 12) {
            // Изображение товара
            AsyncImage(url: URL(string: item.product.image_url)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .overlay(ProgressView())
            }
            .frame(width: 100, height: 100)
            .clipped()
            .cornerRadius(12)
            
            // Информация о товаре
            VStack(alignment: .leading, spacing: 4) {
                Text(item.product.brand)
                    .font(.system(size: 14, weight: .medium))
                Text(item.product.product_name)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                Text(item.product.formattedPrice)
                    .font(.system(size: 14, weight: .semibold))
                    .padding(.top, 4)
            }
            
            Spacer()
            
            // Управление количеством и удаление
            VStack(spacing: 8) {
                // Кнопка уменьшения количества
                Button(action: {
                    if quantity > 1 {
                        quantity -= 1
                        onQuantityChange(quantity)
                    }
                }) {
                    Image(systemName: "minus.circle")
                        .font(.system(size: 20))
                        .foregroundColor(quantity > 1 ? .primary : .secondary)
                }
                .disabled(quantity <= 1) // Нельзя уменьшить меньше 1
                
                // Текущее количество
                Text("\(quantity)")
                    .font(.system(size: 16, weight: .semibold))
                    .frame(minWidth: 30)
                
                // Кнопка увеличения количества
                Button(action: {
                    quantity += 1
                    onQuantityChange(quantity)
                }) {
                    Image(systemName: "plus.circle")
                        .font(.system(size: 20))
                        .foregroundColor(.primary)
                }
                
                // Кнопка удаления товара
                Button(action: onRemove) {
                    Image(systemName: "trash")
                        .font(.system(size: 16))
                        .foregroundColor(.red)
                }
                .padding(.top, 4)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}
