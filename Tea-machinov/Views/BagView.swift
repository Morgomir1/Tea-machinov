import SwiftUI

// Экран корзины с товарами
struct BagView: View {
    @EnvironmentObject var cartService: CartService
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if cartService.items.isEmpty {
                    emptyStateView
                } else {
                    productsList
                    checkoutSection
                }
            }
            .navigationTitle("Bag")
            .navigationBarTitleDisplayMode(.large)
        }
        .navigationViewStyle(.stack)
        .environmentObject(cartService)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "bag")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            Text("Корзина пуста")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.secondary)
            Text("Добавьте товары в корзину, чтобы они появились здесь")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var productsList: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(cartService.items) { item in
                    CartItemRow(
                        item: item,
                        onQuantityChange: { newQuantity in
                            cartService.updateQuantity(for: item.product, quantity: newQuantity)
                        },
                        onRemove: {
                            cartService.removeProduct(item.product)
                        }
                    )
                }
            }
            .padding()
        }
    }
    
    private var checkoutSection: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Итого:")
                    .font(.system(size: 18, weight: .semibold))
                Spacer()
                Text(cartService.formattedTotalPrice)
                    .font(.system(size: 20, weight: .bold))
            }
            .padding(.horizontal)
            
            // Кнопка оформления заказа
            Button(action: {
                print("Оформление заказа на сумму \(cartService.formattedTotalPrice)")
            }) {
                HStack {
                    Spacer()
                    Text("Оформить заказ")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding()
                .background(Color.black)
                .cornerRadius(12)
            }
            .padding(.horizontal)
        }
        .padding(.vertical)
        .background(Color(.systemBackground))
    }
}
