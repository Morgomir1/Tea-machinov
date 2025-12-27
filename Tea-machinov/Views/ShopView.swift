import SwiftUI

// Экран магазина с поиском и фильтрацией
struct ShopView: View {
    @EnvironmentObject var productService: ProductService
    @State private var selectedCategory: String
    let initialCategory: String?
    let showBackButton: Bool
    let showNewProductsOnly: Bool
    
    init(initialCategory: String? = nil, showBackButton: Bool = false, showNewProductsOnly: Bool = false) {
        _selectedCategory = State(initialValue: initialCategory ?? "Men")
        self.initialCategory = initialCategory
        self.showBackButton = showBackButton
        self.showNewProductsOnly = showNewProductsOnly
    }
    
    @State private var selectedBestSellerCategory: String = "Socks"
    @State private var searchText = ""
    @State private var isSearchActive = false
    @FocusState private var isSearchFieldFocused: Bool
    
    let categories = ["Men", "Women", "Kids"]
    let bestSellerCategories = ["Socks", "Accessories & Equipment", "Player", "Training"]
    
    @Environment(\.dismiss) var dismiss
    
    var searchResults: [Product] {
        productService.searchProducts(query: searchText)
    }
    
    var filteredProductsByCategory: [Product] {
        let baseProducts = showNewProductsOnly ? productService.getNewProducts() : productService.products
        return baseProducts.filter { product in
            ProductFilterUtils.matchesCategory(product: product, category: selectedCategory)
        }
    }
    
    var filteredBestsellers: [Product] {
        let bestsellers = productService.getBestsellers()
        let categoryFiltered = bestsellers.filter { product in
            ProductFilterUtils.matchesCategory(product: product, category: selectedCategory)
        }
        return categoryFiltered.filter { product in
            ProductFilterUtils.matchesSubCategory(product: product, subCategory: selectedBestSellerCategory)
        }
    }
    
    var body: some View {
        Group {
            if showBackButton {
                shopContent
                    .navigationTitle("Shop")
                    .navigationBarTitleDisplayMode(.large)
                    .navigationBarBackButtonHidden(true)
                    .toolbar {
                        toolbarContent
                    }
            } else {
                NavigationView {
                    shopContent
                        .navigationTitle("Shop")
                        .navigationBarTitleDisplayMode(.large)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                searchToolbarItem
                            }
                        }
                }
                .navigationViewStyle(.stack)
            }
        }
    }
    
    private var shopContent: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if !searchText.isEmpty {
                    searchResultsView
                } else {
                    shopContentView
                }
            }
            .padding(.vertical)
        }
    }
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
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
            searchToolbarItem
        }
    }
    
    private var searchToolbarItem: some View {
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
        }
    }
    
    private var searchResultsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Результаты поиска: \"\(searchText)\"")
                .font(.system(size: 18, weight: .semibold))
                .padding(.horizontal)
            
            if searchResults.isEmpty {
                emptySearchState
            } else {
                productsGrid(products: searchResults)
            }
        }
    }
    
    private var emptySearchState: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 50))
                .foregroundColor(.secondary)
            Text("Товары не найдены")
                .font(.system(size: 16))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }
    
    private var shopContentView: some View {
        VStack(alignment: .leading, spacing: 20) {
            if !showNewProductsOnly {
                categoryTabs
            }
            
            categoryCollectionSection
            
            if !showNewProductsOnly {
                mustHavesSection
                bannerSection
                bestSellersSection
                shoesSection
            }
        }
    }
    
    private var categoryTabs: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(categories, id: \.self) { category in
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedCategory = category
                        }
                    }) {
                        VStack(spacing: 8) {
                            Text(category)
                                .font(.system(size: 16, weight: selectedCategory == category ? .semibold : .regular))
                                .foregroundColor(selectedCategory == category ? .primary : .secondary)
                            
                            Rectangle()
                                .fill(selectedCategory == category ? Color.primary : Color.clear)
                                .frame(height: 2)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)
            
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(height: 1)
                .padding(.top, 8)
        }
    }
    
    private var categoryCollectionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(showNewProductsOnly ? "New Collection" : "\(selectedCategory) Collection")
                .font(.system(size: 24, weight: .bold))
                .padding(.horizontal)
            
            let categoryProducts = showNewProductsOnly ? productService.getNewProducts() : filteredProductsByCategory
            if !categoryProducts.isEmpty {
                productsGrid(products: categoryProducts)
            } else {
                emptyCategoryState(category: selectedCategory)
            }
        }
        .padding(.top, 16)
    }
    
    private func emptyCategoryState(category: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "tray")
                .font(.system(size: 50))
                .foregroundColor(.secondary)
            Text(showNewProductsOnly ? "Новые товары не найдены" : "Товары категории \"\(category)\" не найдены")
                .font(.system(size: 16))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }
    
    private var mustHavesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Must-Haves, Best Sellers & More")
                .font(.system(size: 18, weight: .semibold))
                .padding(.horizontal)
            
            VStack(spacing: 8) {
                HStack(spacing: 12) {
                    NavigationLink(destination: CategoryView(categoryName: "Best Sellers")) {
                        CategoryCard(title: "Best Sellers", imageName: "crossovki", height: 180)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    NavigationLink(destination: CategoryView(categoryName: "Featured in Nike Air")) {
                        CategoryCard(title: "Featured in Nike Air", imageName: "muzhik1", height: 180)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.horizontal)
                
                HStack(spacing: 12) {
                    NavigationLink(destination: CategoryView(categoryName: "New Arrivals")) {
                        CategoryCard(title: "New Arrivals", imageName: "tetka1", height: 180)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    NavigationLink(destination: CategoryView(categoryName: "Special Offers")) {
                        CategoryCard(title: "Special Offers", imageName: "tetka2", height: 180)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.horizontal)
            }
        }
        .padding(.top, 8)
    }
    
    private var bannerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            BannerCard(title: "New & Featured", imageName: "crossovki2", height: 200)
                .padding(.horizontal)
        }
        .padding(.top, 8)
    }
    
    private var bestSellersSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Best Sellers")
                .font(.system(size: 24, weight: .bold))
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(bestSellerCategories, id: \.self) { category in
                        Button(action: {
                            selectedBestSellerCategory = category
                        }) {
                            VStack(spacing: 4) {
                                Text(category)
                                    .font(.system(size: 14, weight: selectedBestSellerCategory == category ? .semibold : .regular))
                                    .foregroundColor(selectedBestSellerCategory == category ? .primary : .secondary)
                                
                                if selectedBestSellerCategory == category {
                                    Rectangle()
                                        .fill(Color.primary)
                                        .frame(height: 2)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            let bestsellers = filteredBestsellers
            if !bestsellers.isEmpty {
                productsGrid(products: Array(bestsellers.prefix(4)))
            }
        }
        .padding(.top, 8)
    }
    
    private var shoesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Shoes")
                .font(.system(size: 18, weight: .semibold))
                .padding(.horizontal)
            
            let shoesProducts = productService.products.filter { product in
                product.category?.lowercased() == "shoes" ||
                product.product_name.lowercased().contains("shoe") ||
                product.product_name.lowercased().contains("sneaker")
            }
            
            if !shoesProducts.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(shoesProducts.prefix(4)) { product in
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
}
