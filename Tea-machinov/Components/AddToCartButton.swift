import SwiftUI

// Кнопка добавления в корзину с анимацией успешного добавления
struct AddToCartButton: View {
    let product: Product
    @EnvironmentObject var cartService: CartService
    // Показывать ли сообщение "Добавлено"
    @State private var showAddedAlert = false
    
    var body: some View {
        Button(action: {
            // Добавляем товар в корзину
            cartService.addProduct(product)
            showAddedAlert = true
            // Через 1.5 секунды скрываем сообщение
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                showAddedAlert = false
            }
        }) {
            HStack {
                Spacer()
                if showAddedAlert {
                    // Показываем галочку и текст "Добавлено"
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark")
                        Text("Добавлено")
                    }
                } else {
                    Text("Добавить в корзину")
                }
                Spacer()
            }
            .font(.system(size: 18, weight: .semibold))
            .foregroundColor(.white)
            .padding()
            // Меняем цвет на зеленый когда добавлено
            .background(showAddedAlert ? Color.green : Color.black)
            .cornerRadius(12)
            .animation(.easeInOut(duration: 0.2), value: showAddedAlert)
        }
    }
}
