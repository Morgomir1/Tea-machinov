//
//  CategoryView.swift
//  Tea-machinov
//
//  Created by user on 04.12.2025.
//

import SwiftUI

struct CategoryView: View {
    let categoryName: String
    @ObservedObject var productService: ProductService
    @Environment(\.dismiss) var dismiss
    @State private var selectedSubCategory: String = "Socks"
    
    let subCategories = ["Socks", "Accessories & Equipment", "Player", "Training"]
    
    var filteredProducts: [Product] {
        // Фильтруем товары по категории
        // Пока возвращаем все товары, так как в JSON нет категорий
        // Можно использовать bestseller для категории "Best Sellers"
        if categoryName == "Best Sellers" {
            return productService.getBestsellers()
        }
        return productService.products
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Горизонтальная прокрутка подкатегорий
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(subCategories, id: \.self) { category in
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
                    }
                    .padding(.horizontal)
                }
                .padding(.top, 8)
                
                // Сетка товаров 2x2
                if !filteredProducts.isEmpty {
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 12),
                        GridItem(.flexible(), spacing: 12)
                    ], spacing: 16) {
                        ForEach(filteredProducts) { product in
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
                    VStack {
                        Text("Товары не найдены")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                            .padding()
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.vertical)
        }
        .navigationTitle(categoryName)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.primary)
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack(spacing: 16) {
                    Button(action: {
                        // Действие фильтра
                    }) {
                        Image(systemName: "line.3.horizontal.decrease")
                            .foregroundColor(.primary)
                    }
                    
                    Button(action: {
                        // Действие поиска
                    }) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.primary)
                    }
                }
            }
        }
    }
}

