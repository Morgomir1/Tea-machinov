import SwiftUI

// Главный экран с табами - основная навигация приложения
struct TabsScreen: View {
    // Какой таб сейчас выбран (0 = Home, 1 = Shop, и т.д.)
    @State private var selectedTab = 0
    // Сервисы для работы с данными - создаем один раз и передаем дальше
    @StateObject private var cartService = CartService()
    @StateObject private var favoritesService = FavoritesService()
    @StateObject private var productService = ProductService()
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Домашний экран
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                .tag(0)
            
            // Экран магазина с поиском
            ShopView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Shop")
                }
                .tag(1)
            
            // Избранные товары
            FavouritesView()
                .tabItem {
                    Image(systemName: "heart")
                    Text("Favourites")
                }
                .tag(2)
            
            // Корзина
            BagView()
                .tabItem {
                    Image(systemName: "bag")
                    Text("Bag")
                }
                .tag(3)
            
            // Профиль пользователя
            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
                .tag(4)
        }
        .accentColor(.blue)
        .onAppear {
            // Настраиваем внешний вид таб-бара
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.systemBackground
            
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
            
            // Связываем сервисы между собой для синхронизации избранного
            productService.setFavoritesService(favoritesService)
        }
        // Передаем сервисы во все дочерние экраны
        .environmentObject(cartService)
        .environmentObject(favoritesService)
        .environmentObject(productService)
    }
}

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
                    
                    // Промо-баннер с изображением из онбординга
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
                .padding(.vertical)
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.large)
        }
        .navigationViewStyle(.stack)
    }
}

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
    
    var searchResults: [Product] {
        productService.searchProducts(query: searchText)
    }
    
    var filteredProductsByCategory: [Product] {
        let baseProducts = showNewProductsOnly ? productService.getNewProducts() : productService.products
        return baseProducts.filter { product in
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
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Group {
            if showBackButton {
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
                .navigationTitle("Shop")
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
                        }
                    }
                }
            } else {
                NavigationView {
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
                    .navigationTitle("Shop")
                    .navigationBarTitleDisplayMode(.large)
                    .toolbar {
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
                            }
                        }
                    }
                }
                .navigationViewStyle(.stack)
            }
        }
    }
    
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
    }
    
    private var shopContentView: some View {
        VStack(alignment: .leading, spacing: 20) {
                    if !showNewProductsOnly {
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
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text(showNewProductsOnly ? "New Collection" : "\(selectedCategory) Collection")
                            .font(.system(size: 24, weight: .bold))
                            .padding(.horizontal)
                        
                        let categoryProducts = showNewProductsOnly ? productService.getNewProducts() : filteredProductsByCategory
                        if !categoryProducts.isEmpty {
                            LazyVGrid(columns: [
                                GridItem(.flexible(), spacing: 12),
                                GridItem(.flexible(), spacing: 12)
                            ], spacing: 16) {
                                ForEach(categoryProducts) { product in
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
                        } else {
                            VStack(spacing: 16) {
                                Image(systemName: "tray")
                                    .font(.system(size: 50))
                                    .foregroundColor(.secondary)
                                Text(showNewProductsOnly ? "Новые товары не найдены" : "Товары категории \"\(selectedCategory)\" не найдены")
                                    .font(.system(size: 16))
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 60)
                        }
                    }
                    .padding(.top, 16)
                    
                    if !showNewProductsOnly {
                        VStack(alignment: .leading, spacing: 16) {
                        Text("Must-Haves, Best Sellers & More")
                            .font(.system(size: 18, weight: .semibold))
                            .padding(.horizontal)
                        
                        HStack(spacing: 12) {
                            NavigationLink(destination: CategoryView(categoryName: "Best Sellers")) {
                                CategoryCard(
                                    title: "Best Sellers",
                                    imageName: "crossovki",
                                    height: 180
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            NavigationLink(destination: CategoryView(categoryName: "Featured in Nike Air")) {
                                CategoryCard(
                                    title: "Featured in Nike Air",
                                    imageName: "muzhik1",
                                    height: 180
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding(.horizontal)
                        
                        HStack(spacing: 12) {
                            NavigationLink(destination: CategoryView(categoryName: "New Arrivals")) {
                                CategoryCard(
                                    title: "New Arrivals",
                                    imageName: "tetka1",
                                    height: 180
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            NavigationLink(destination: CategoryView(categoryName: "Special Offers")) {
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
                    }
                    
                    if !showNewProductsOnly {
                        VStack(alignment: .leading, spacing: 12) {
                        BannerCard(
                            title: "New & Featured",
                            imageName: "crossovki2",
                            height: 200
                        )
                        .padding(.horizontal)
                    }
                    .padding(.top, 8)
                    }
                    
                    if !showNewProductsOnly {
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
                            LazyVGrid(columns: [
                                GridItem(.flexible(), spacing: 12),
                                GridItem(.flexible(), spacing: 12)
                            ], spacing: 16) {
                                ForEach(bestsellers.prefix(4)) { product in
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
                    .padding(.top, 8)
                    }
                    
            if !showNewProductsOnly {
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
        }
    }
}

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
            .navigationTitle("Favourites")
            .navigationBarTitleDisplayMode(.large)
        }
        .navigationViewStyle(.stack)
    }
}

// Экран корзины с товарами
struct BagView: View {
    @EnvironmentObject var cartService: CartService
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if cartService.items.isEmpty {
                    // Если корзина пуста - показываем сообщение
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
                    // Список товаров в корзине
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(cartService.items) { item in
                                CartItemRow(
                                    item: item,
                                    onQuantityChange: { newQuantity in
                                        // Обновляем количество товара
                                        cartService.updateQuantity(for: item.product, quantity: newQuantity)
                                    },
                                    onRemove: {
                                        // Удаляем товар из корзины
                                        cartService.removeProduct(item.product)
                                    }
                                )
                            }
                        }
                        .padding()
                    }
                    
                    // Итого и кнопка оформления заказа
                    VStack(spacing: 12) {
                        HStack {
                            Text("Итого:")
                                .font(.system(size: 18, weight: .semibold))
                            Spacer()
                            Text(cartService.formattedTotalPrice)
                                .font(.system(size: 20, weight: .bold))
                        }
                        .padding(.horizontal)
                        
                        // Кнопка оформления заказа (пока только выводит в консоль)
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
            .navigationTitle("Bag")
            .navigationBarTitleDisplayMode(.large)
        }
        .navigationViewStyle(.stack)
        .environmentObject(cartService)
    }
}

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

// Экран профиля пользователя (пока заглушка)
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
