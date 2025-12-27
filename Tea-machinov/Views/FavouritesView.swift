import SwiftUI

// Экран избранных товаров
struct FavouritesView: View {
    @EnvironmentObject var productService: ProductService
    @EnvironmentObject var favoritesService: FavoritesService
    
    var likedProducts: [Product] {
        productService.getFavoriteProducts()
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                if likedProducts.isEmpty {
                    emptyStateView
                } else {
                    productsGrid
                }
            }
            .navigationTitle("Favourites")
            .navigationBarTitleDisplayMode(.large)
        }
        .navigationViewStyle(.stack)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "heart")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            Text("Нет избранных товаров")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.secondary)
            Text("Добавьте товары в избранное, нажав на иконку сердца")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 100)
    }
    
    private var productsGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 12),
            GridItem(.flexible(), spacing: 12)
        ], spacing: 16) {
            ForEach(likedProducts) { product in
                NavigationLink(destination: ProductDetailView(productId: product.id)) {
                    ProductGridCard(
                        product: product,
                        onLikeToggle: {
                            productService.toggleLike(for: product)
                        }
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.horizontal)
        .padding(.vertical)
    }
}
