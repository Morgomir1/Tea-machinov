import SwiftUI

// Экран с детальной информацией о товаре
struct ProductDetailView: View {
    // ID товара для которого показываем детали
    let productId: UUID
    // Сервис товаров (получаем из окружения)
    @EnvironmentObject var productService: ProductService
    // Для закрытия экрана
    @Environment(\.dismiss) var dismiss
    @State private var selectedImageIndex = 0
    
    // Находим товар по ID в списке товаров
    private var product: Product? {
        productService.products.first { $0.id == productId }
    }
    
    var body: some View {
        Group {
            if let product = product {
                // Если товар найден - показываем детали
                productDetailContent(for: product)
            } else {
                // Если не найден - показываем сообщение
                Text("Товар не найден")
                    .foregroundColor(.secondary)
            }
        }
    }
    
    // Основной контент экрана деталей товара
    private func productDetailContent(for product: Product) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Изображение товара с кнопкой избранного
                ZStack(alignment: .topTrailing) {
                    // Асинхронная загрузка изображения
                    AsyncImage(url: URL(string: product.image_url)) { phase in
                        switch phase {
                        case .empty:
                            // Пока загружается - показываем индикатор
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .overlay(ProgressView())
                        case .success(let image):
                            // Изображение загружено - показываем
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        case .failure:
                            // Ошибка загрузки - показываем иконку
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .overlay(
                                    Image(systemName: "photo")
                                        .foregroundColor(.gray)
                                )
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .frame(height: 400)
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray6))
                    
                    // Кнопка избранного в правом верхнем углу
                    Button(action: {
                        productService.toggleLike(for: product)
                    }) {
                        Image(systemName: product.is_liked ? "heart.fill" : "heart")
                            .foregroundColor(product.is_liked ? .red : .white)
                            .font(.system(size: 20))
                            .padding(12)
                            .background(Color.black.opacity(0.3))
                            .clipShape(Circle())
                    }
                    .padding(16)
                }
                
                // Информация о товаре
                VStack(alignment: .leading, spacing: 12) {
                    // Бейджи (бестселлер, распродан)
                    HStack(spacing: 8) {
                        if product.is_bestseller {
                            Text("Bestseller")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.black)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(Color.yellow)
                                .cornerRadius(6)
                        }
                        
                        if product.isSoldOut {
                            Text("Sold Out")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(Color.orange)
                                .cornerRadius(6)
                        }
                    }
                    
                    // Бренд
                    Text(product.brand)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.secondary)
                    
                    // Название товара
                    Text(product.product_name)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.primary)
                    
                    // Цена
                    Text(product.formattedPrice)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.primary)
                        .padding(.top, 4)
                    
                    Divider()
                        .padding(.vertical, 8)
                    
                    // Остаток товара в наличии
                    HStack {
                        Text("Осталось в наличии:")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        // Показываем количество, зеленым если есть, красным если нет
                        Text("\(product.items_left) шт.")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(product.items_left > 0 ? .green : .red)
                    }
                    
                    Divider()
                        .padding(.vertical, 8)
                    
                    // Описание товара (если есть)
                    if let description = product.description, !description.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Описание")
                                .font(.system(size: 18, weight: .semibold))
                            
                            Text(description)
                                .font(.system(size: 16))
                                .foregroundColor(.secondary)
                                .lineSpacing(4)
                        }
                        .padding(.top, 8)
                    }
                }
                .padding(.horizontal)
                
                // Кнопка добавления в корзину (показываем только если товар в наличии)
                if !product.isSoldOut {
                    AddToCartButton(product: product)
                        .padding(.horizontal)
                        .padding(.top, 8)
                } else {
                    // Если распродан - показываем неактивную кнопку
                    Button(action: {}) {
                        HStack {
                            Spacer()
                            Text("Нет в наличии")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding()
                        .background(Color.gray)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                    .disabled(true)
                }
            }
            .padding(.bottom, 20)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            // Кастомная кнопка назад
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                }
            }
        }
    }
}

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

