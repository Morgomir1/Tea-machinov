//
//  TabsScreen.swift
//  Tea-machinov
//
//  Created by user on 28.11.2025.
//

import SwiftUI

struct TabsScreen: View {
    @State private var selectedTab = 0
    
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
    }
}

// MARK: - Home View
struct HomeView: View {
    @StateObject private var productService = ProductService()
    @State private var searchText = ""
    
    let interests = [
        ("Running", "muzhik1"),
        ("Training", "crossovki"),
        ("Basketball", "crossovki2")
    ]
    
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
                                // Действие добавления интереса
                            }
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                        }
                        .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(interests, id: \.0) { interest in
                                    InterestCard(title: interest.0, imageName: interest.1)
                                }
                            }
                            .padding(.horizontal)
                        }
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
            .navigationTitle("Shop")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        print("Search for: \(searchText)")
                    }) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.primary)
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

// MARK: - Shop View
struct ShopView: View {
    @StateObject private var productService = ProductService()
    @State private var selectedCategory: String = "Men"
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
            .toolbar {
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
                        
                        // Кнопка фильтра
                        Button(action: {
                            // Действие фильтра
                        }) {
                            Image(systemName: "line.3.horizontal.decrease.circle")
                                .foregroundColor(.primary)
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
                    
            // Дополнительный контент (можно добавить больше секций)
            VStack(alignment: .leading, spacing: 12) {
                Text("Shoes")
                    .font(.system(size: 18, weight: .semibold))
                    .padding(.horizontal)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(["crossovki3", "crossovki4"], id: \.self) { imageName in
                            ProductCard(imageName: imageName)
                        }
                    }
                    .padding(.horizontal)
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
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()
                
                VStack {
                    Text("Favourites Screen")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Image(systemName: "heart.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.red)
                        .padding()
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
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()
                
                VStack {
                    Text("Bag Screen")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Image(systemName: "bag.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.orange)
                        .padding()
                }
            }
            .navigationTitle("Bag")
            .navigationBarTitleDisplayMode(.large)
        }
        .navigationViewStyle(.stack)
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
