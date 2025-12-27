import SwiftUI

// Экран категории товаров с подкатегориями и поиском
struct CategoryView: View {
    // Название категории (например, "Best Sellers")
    let categoryName: String
    @EnvironmentObject var productService: ProductService
    @Environment(\.dismiss) var dismiss
    // Выбранная подкатегория
    @State private var selectedSubCategory: String = "Socks"
    @State private var showFilters = false
    @State private var isSearchActive = false
    @State private var searchText = ""
    @FocusState private var isSearchFieldFocused: Bool
    
    // Доступные подкатегории
    let subCategories = ["Socks", "Accessories & Equipment", "Player", "Training"]
    
    // Фильтруем товары по категории, поиску и подкатегории
    var filteredProducts: [Product] {
        var products: [Product] = productService.products
        // Если это категория бестселлеров - берем только их
        if categoryName == "Best Sellers" {
            products = productService.getBestsellers()
        }
        
        // Если есть поисковый запрос - фильтруем по нему
        if !searchText.isEmpty {
            let searchResults = productService.searchProducts(query: searchText)
            products = searchResults
        }
        
        // Фильтруем по выбранной подкатегории
        let subCategoryFiltered = products.filter { product in
            matchesSubCategory(product: product, subCategory: selectedSubCategory)
        }
        
        return subCategoryFiltered
    }
    
    // Проверяем, подходит ли товар под подкатегорию (ищем ключевые слова в названии и бренде)
    private func matchesSubCategory(product: Product, subCategory: String) -> Bool {
        let productName = product.product_name.lowercased()
        let brand = product.brand.lowercased()
        let combined = "\(productName) \(brand)".lowercased()
        
        switch subCategory {
        case "Socks":
            // Ищем слова связанные с носками
            return combined.contains("sock") || 
                   combined.contains("носки") ||
                   productName.contains("sock")
        case "Accessories & Equipment":
            // Ищем аксессуары и оборудование
            return combined.contains("backpack") ||
                   combined.contains("bag") ||
                   combined.contains("equipment") ||
                   combined.contains("accessories") ||
                   combined.contains("аксессуар") ||
                   combined.contains("рюкзак")
        case "Player":
            // Товары для игроков (баскетбол, Jordan и т.д.)
            return combined.contains("player") ||
                   combined.contains("basketball") ||
                   combined.contains("jordan") ||
                   combined.contains("игрок") ||
                   brand.contains("jordan")
        case "Training":
            // Товары для тренировок
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
    
    var body: some View {
        let products = filteredProducts
        let hasProducts = !products.isEmpty
        
        return ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                categoryScrollView
                
                if hasProducts {
                    productsGrid(products: products)
                } else {
                    emptyStateView
                }
            }
            .padding(.vertical)
        }
        .navigationTitle(categoryName)
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack(spacing: 12) {
                    if isSearchActive {
                        TextField("Поиск товаров", text: $searchText)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 200)
                            .focused($isSearchFieldFocused)
                            .transition(.opacity)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    isSearchFieldFocused = true
                                }
                            }
                    }
                    
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            if isSearchActive {
                                isSearchActive = false
                                searchText = ""
                                isSearchFieldFocused = false
                            } else {
                                isSearchActive = true
                            }
                        }
                    }) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.primary)
                    }
                    
                    Button(action: {
                        showFilters = true
                    }) {
                        Image(systemName: "line.3.horizontal.decrease")
                            .foregroundColor(.primary)
                    }
                }
            }
        }
        .sheet(isPresented: $showFilters) {
            FilterView()
        }
    }
    
    private var categoryScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(subCategories, id: \.self) { category in
                    categoryButton(category: category)
                }
            }
            .padding(.horizontal)
        }
        .padding(.top, 8)
    }
    
    private func categoryButton(category: String) -> some View {
        Button(action: {
            selectedSubCategory = category
        }) {
            VStack(spacing: 4) {
                Text(category)
                    .font(.system(size: 14, weight: selectedSubCategory == category ? .semibold : .regular))
                    .foregroundColor(selectedSubCategory == category ? .primary : .secondary)
                
                if selectedSubCategory == category {
                    Rectangle()
                        .fill(Color.primary)
                        .frame(height: 2)
                }
            }
        }
    }
    
    private func productsGrid(products: [Product]) -> some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 12),
            GridItem(.flexible(), spacing: 12)
        ], spacing: 16) {
            ForEach(products) { product in
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
    }
    
    private var emptyStateView: some View {
        VStack {
            Text("Товары не найдены")
                .font(.system(size: 16))
                .foregroundColor(.secondary)
                .padding()
        }
        .frame(maxWidth: .infinity)
    }
}

