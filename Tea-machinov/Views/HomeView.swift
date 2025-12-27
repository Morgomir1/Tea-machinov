import SwiftUI

// Домашний экран с интересами и рекомендациями
struct HomeView: View {
    // Сервис для работы с товарами (получаем из родительского экрана)
    @EnvironmentObject var productService: ProductService
    // Сервис для управления интересами пользователя
    @StateObject private var interestService = InterestService()
    @State private var searchText = ""
    // Показывать ли модальное окно для добавления интересов
    @State private var showAddInterestSheet = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Секция с интересами пользователя
                    interestsSection
                    
                    // Промо-баннер с изображением из онбординга
                    promoBannerSection
                    
                    // Рекомендуемые товары
                    recommendedSection
                }
                .padding(.vertical)
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.large)
        }
        .navigationViewStyle(.stack)
    }
    
    private var interestsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Shop My Interests")
                    .font(.system(size: 24, weight: .bold))
                
                Spacer()
                
                // Кнопка для добавления новых интересов
                Button("Add Interest") {
                    showAddInterestSheet = true
                }
                .font(.system(size: 14))
                .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(interestService.selectedInterests) { interest in
                        NavigationLink(destination: ShopView(initialCategory: interest.category, showBackButton: true)) {
                            InterestCard(title: interest.title, imageName: interest.imageName)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.top, 8)
        .sheet(isPresented: $showAddInterestSheet) {
            AddInterestView(interestService: interestService)
        }
    }
    
    private var promoBannerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            NavigationLink(destination: ShopView(showBackButton: true, showNewProductsOnly: true)) {
                PromoBannerCard(
                    title: "New Collection",
                    subtitle: "Discover the latest styles",
                    imageName: "crossovki4",
                    height: 200
                )
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.horizontal)
        }
        .padding(.top, 8)
    }
    
    private var recommendedSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recommended for You")
                .font(.system(size: 24, weight: .bold))
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(productService.getRecommendedProducts()) { product in
                        NavigationLink(destination: ProductDetailView(productId: product.id)) {
                            RecommendedProductCard(
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
            }
        }
    }
}
