//
//  TabsScreen.swift
//  Tea-machinov
//
//  Created by user on 28.11.2025.
//

import SwiftUI

struct TabsScreen: View {
    @State private var selectedTab = 0
    @StateObject private var cartService = CartService()
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                .tag(0)
            
            ShopView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Shop")
                }
                .tag(1)
            
            FavouritesView()
                .tabItem {
                    Image(systemName: "heart")
                    Text("Favourites")
                }
                .tag(2)
            
            BagView()
                .tabItem {
                    Image(systemName: "bag")
                    Text("Bag")
                }
                .tag(3)
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
                .tag(4)
        }
        .accentColor(.blue)
        // Используем стандартный стиль таб-бара iOS
        .onAppear {
            // Настройка внешнего вида таб-бара (опционально)
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.systemBackground
            
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
        .environmentObject(cartService)
    }
}

// MARK: - Home View
struct HomeView: View {
    @StateObject private var productService = ProductService()
    @StateObject private var interestService = InterestService()
    @State private var searchText = ""
    @State private var showAddInterestSheet = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Секция "Shop My Interests"
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Shop My Interests")
                                .font(.system(size: 24, weight: .bold))
                            
                            Spacer()
                            
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
                                    NavigationLink(destination: ShopView(initialCategory: interest.category)) {
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
                    
                    // Промо-баннер с изображением из онбординга
                    VStack(alignment: .leading, spacing: 12) {
                        PromoBannerCard(
                            title: "New Collection",
                            subtitle: "Discover the latest styles",
                            imageName: "crossovki4",
                            height: 200
                        )
                        .padding(.horizontal)
                    }
                    .padding(.top, 8)
                    
                    // Секция "Recommended for You"
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Recommended for You")
                            .font(.system(size: 24, weight: .bold))
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(productService.getRecommendedProducts()) { product in
                                    NavigationLink(destination: ProductDetailView(productId: product.id, productService: productService)) {
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
                .padding(.vertical)
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.large)
        }
        .navigationViewStyle(.stack)
    }
}

// MARK: - Shop View
struct ShopView: View {
    @StateObject private var productService = ProductService()
    @State private var selectedCategory: String
    let initialCategory: String?
    
    init(initialCategory: String? = nil) {
        _selectedCategory = State(initialValue: initialCategory ?? "Men")
        self.initialCategory = initialCategory
    }
    @State private var selectedBestSellerCategory: String = "Socks"
    @State private var searchText = ""
    @State private var isSearchActive = false
    @FocusState private var isSearchFieldFocused: Bool
    
    let categories = ["Men", "Women", "Kids"]
    let bestSellerCategories = ["Socks", "Accessories & Equipment", "Player", "Training"]
    
    var searchResults: [Product] {
        productService.searchProducts(query: searchText)
    }
    
    var filteredProductsByCategory: [Product] {
        productService.products.filter { product in
            matchesCategory(product: product, category: selectedCategory)
        }
    }
    
    var filteredBestsellers: [Product] {
        let bestsellers = productService.getBestsellers()
        let categoryFiltered = bestsellers.filter { product in
            matchesCategory(product: product, category: selectedCategory)
        }
        return categoryFiltered.filter { product in
            matchesSubCategory(product: product, subCategory: selectedBestSellerCategory)
        }
    }
    
    private func matchesCategory(product: Product, category: String) -> Bool {
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
    
    private func matchesSubCategory(product: Product, subCategory: String) -> Bool {
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
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Если есть поисковый запрос, показываем результаты поиска
                    if !searchText.isEmpty {
                        searchResultsView
                    } else {
                        // Обычный контент магазина
                        shopContentView
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Shop")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.blue)
                            Text("Home")
                                .font(.system(size: 17))
                                .foregroundColor(.blue)
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 12) {
                        // Поле поиска, показывается при активации
                        if isSearchActive {
                            TextField("Поиск товаров", text: $searchText)
                                .textFieldStyle(.roundedBorder)
                                .frame(width: 200)
                                .focused($isSearchFieldFocused)
                                .transition(.opacity)
                                .onAppear {
                                    // Автоматически фокусируем поле при появлении
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        isSearchFieldFocused = true
                                    }
                                }
                        }
                        
                        // Кнопка поиска
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                if isSearchActive {
                                    // Закрываем поиск
                                    isSearchActive = false
                                    searchText = ""
                                    isSearchFieldFocused = false
                                } else {
                                    // Открываем поиск
                                    isSearchActive = true
                                }
                            }
                        }) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
    }
    
    // MARK: - Search Results View
    private var searchResultsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Результаты поиска: \"\(searchText)\"")
                .font(.system(size: 18, weight: .semibold))
                .padding(.horizontal)
            
            if searchResults.isEmpty {
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
            } else {
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12)
                ], spacing: 16) {
                    ForEach(searchResults) { product in
                        NavigationLink(destination: ProductDetailView(productId: product.id, productService: productService)) {
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
    }
    
    // MARK: - Shop Content View
    private var shopContentView: some View {
        VStack(alignment: .leading, spacing: 20) {
                    // Категории как переключаемые табы
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
                        
                        // Разделительная линия под табами
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 1)
                            .padding(.top, 8)
                    }
                    
                    // Секция с продуктами выбранной категории
                    VStack(alignment: .leading, spacing: 16) {
                        Text("\(selectedCategory) Collection")
                            .font(.system(size: 24, weight: .bold))
                            .padding(.horizontal)
                        
                        let categoryProducts = filteredProductsByCategory
                        if !categoryProducts.isEmpty {
                            LazyVGrid(columns: [
                                GridItem(.flexible(), spacing: 12),
                                GridItem(.flexible(), spacing: 12)
                            ], spacing: 16) {
                                ForEach(categoryProducts.prefix(6)) { product in
                                    NavigationLink(destination: ProductDetailView(productId: product.id, productService: productService)) {
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
                        } else {
                            VStack(spacing: 16) {
                                Image(systemName: "tray")
                                    .font(.system(size: 50))
                                    .foregroundColor(.secondary)
                                Text("Товары категории \"\(selectedCategory)\" не найдены")
                                    .font(.system(size: 16))
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 60)
                        }
                    }
                    .padding(.top, 16)
                    
                    // Секция "Must-Haves, Best Sellers & More"
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Must-Haves, Best Sellers & More")
                            .font(.system(size: 18, weight: .semibold))
                            .padding(.horizontal)
                        
                        // Две карточки рядом
                        HStack(spacing: 12) {
                            // Карточка "Best Sellers"
                            NavigationLink(destination: CategoryView(categoryName: "Best Sellers", productService: productService)) {
                                CategoryCard(
                                    title: "Best Sellers",
                                    imageName: "crossovki",
                                    height: 180
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            // Карточка "Featured in Nike Air"
                            NavigationLink(destination: CategoryView(categoryName: "Featured in Nike Air", productService: productService)) {
                                CategoryCard(
                                    title: "Featured in Nike Air",
                                    imageName: "muzhik1",
                                    height: 180
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding(.horizontal)
                        
                        // Дополнительные карточки с изображениями из онбординга
                        HStack(spacing: 12) {
                            NavigationLink(destination: CategoryView(categoryName: "New Arrivals", productService: productService)) {
                                CategoryCard(
                                    title: "New Arrivals",
                                    imageName: "tetka1",
                                    height: 180
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            NavigationLink(destination: CategoryView(categoryName: "Special Offers", productService: productService)) {
                                CategoryCard(
                                    title: "Special Offers",
                                    imageName: "tetka2",
                                    height: 180
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                    }
                    .padding(.top, 8)
                    
                    // Баннер "New & Featured"
                    VStack(alignment: .leading, spacing: 12) {
                        BannerCard(
                            title: "New & Featured",
                            imageName: "crossovki2",
                            height: 200
                        )
                        .padding(.horizontal)
                    }
                    .padding(.top, 8)
                    
                    // Секция "Best Sellers"
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Best Sellers")
                            .font(.system(size: 24, weight: .bold))
                            .padding(.horizontal)
                        
                        // Горизонтальная прокрутка категорий Best Sellers
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
                        
                        // Сетка товаров 2x2
                        let bestsellers = filteredBestsellers
                        if !bestsellers.isEmpty {
                            LazyVGrid(columns: [
                                GridItem(.flexible(), spacing: 12),
                                GridItem(.flexible(), spacing: 12)
                            ], spacing: 16) {
                                ForEach(bestsellers.prefix(4)) { product in
                                    NavigationLink(destination: ProductDetailView(productId: product.id, productService: productService)) {
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
                    .padding(.top, 8)
                    
            // Дополнительный контент - секция Shoes
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
                                NavigationLink(destination: ProductDetailView(productId: product.id, productService: productService)) {
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
    }
}

// MARK: - Category Card Component
struct CategoryCard: View {
    let title: String
    let imageName: String
    let height: CGFloat
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            GeometryReader { geometry in
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: height)
                    .clipped()
            }
            .frame(height: height)
            .cornerRadius(12)
            
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .padding(.top, 8)
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Banner Card Component
struct BannerCard: View {
    let title: String
    let imageName: String
    let height: CGFloat
    
    var body: some View {
        ZStack(alignment: .leading) {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: height)
                .clipped()
                .cornerRadius(12)
            
            // Градиент для лучшей читаемости текста
            LinearGradient(
                gradient: Gradient(colors: [Color.black.opacity(0.3), Color.clear]),
                startPoint: .leading,
                endPoint: .trailing
            )
            .cornerRadius(12)
            
            Text(title)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
                .padding(.leading, 20)
                .padding(.top, 20)
        }
    }
}

// MARK: - Promo Banner Card Component
struct PromoBannerCard: View {
    let title: String
    let subtitle: String
    let imageName: String
    let height: CGFloat
    
    var body: some View {
        ZStack(alignment: .leading) {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: height)
                .clipped()
                .cornerRadius(12)
            
            // Градиент для лучшей читаемости текста
            LinearGradient(
                gradient: Gradient(colors: [Color.black.opacity(0.4), Color.clear]),
                startPoint: .leading,
                endPoint: .trailing
            )
            .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                Text(subtitle)
                    .font(.system(size: 16))
                    .foregroundColor(.white.opacity(0.9))
            }
            .padding(.leading, 20)
            .padding(.top, 20)
        }
    }
}

// MARK: - Product Card Component
struct ProductCard: View {
    let imageName: String
    
    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height: 150)
                .clipped()
                .cornerRadius(12)
        }
    }
}

// MARK: - Favourites View
struct FavouritesView: View {
    @StateObject private var productService = ProductService()
    
    var likedProducts: [Product] {
        productService.products.filter { $0.is_liked }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                if likedProducts.isEmpty {
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
                } else {
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 12),
                        GridItem(.flexible(), spacing: 12)
                    ], spacing: 16) {
                        ForEach(likedProducts) { product in
                            NavigationLink(destination: ProductDetailView(productId: product.id, productService: productService)) {
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
            .navigationTitle("Favourites")
            .navigationBarTitleDisplayMode(.large)
        }
        .navigationViewStyle(.stack)
    }
}

// MARK: - Bag View
struct BagView: View {
    @EnvironmentObject var cartService: CartService
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if cartService.items.isEmpty {
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
                } else {
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
                    
                    // Итого и кнопка оформления
                    VStack(spacing: 12) {
                        HStack {
                            Text("Итого:")
                                .font(.system(size: 18, weight: .semibold))
                            Spacer()
                            Text(cartService.formattedTotalPrice)
                                .font(.system(size: 20, weight: .bold))
                        }
                        .padding(.horizontal)
                        
                        Button(action: {
                            // Действие оформления заказа
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
            .navigationTitle("Bag")
            .navigationBarTitleDisplayMode(.large)
        }
        .navigationViewStyle(.stack)
        .environmentObject(cartService)
    }
}

// MARK: - Cart Item Row
struct CartItemRow: View {
    let item: CartItem
    let onQuantityChange: (Int) -> Void
    let onRemove: () -> Void
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
            
            // Управление количеством
            VStack(spacing: 8) {
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
                .disabled(quantity <= 1)
                
                Text("\(quantity)")
                    .font(.system(size: 16, weight: .semibold))
                    .frame(minWidth: 30)
                
                Button(action: {
                    quantity += 1
                    onQuantityChange(quantity)
                }) {
                    Image(systemName: "plus.circle")
                        .font(.system(size: 20))
                        .foregroundColor(.primary)
                }
                
                // Кнопка удаления
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

// MARK: - Profile View
struct ProfileView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()
                
                VStack {
                    Text("Profile Screen")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Image(systemName: "person.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.purple)
                        .padding()
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
        }
        .navigationViewStyle(.stack)
    }
}

#Preview {
    TabsScreen()
}
