//
//  ProductDetailView.swift
//  Tea-machinov
//
//  Created by user on 04.12.2025.
//

import SwiftUI

struct ProductDetailView: View {
    let productId: UUID
    @ObservedObject var productService: ProductService
    @Environment(\.dismiss) var dismiss
    @State private var selectedImageIndex = 0
    
    // Получаем актуальный товар из productService
    private var product: Product? {
        productService.products.first { $0.id == productId }
    }
    
    var body: some View {
        Group {
            if let product = product {
                productDetailContent(for: product)
            } else {
                Text("Товар не найден")
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private func productDetailContent(for product: Product) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Изображение товара
                ZStack(alignment: .topTrailing) {
                    AsyncImage(url: URL(string: product.image_url)) { phase in
                        switch phase {
                        case .empty:
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .overlay(ProgressView())
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        case .failure:
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
                    
                    // Кнопка избранного
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
                    // Бейджи
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
                    
                    // Название продукта
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
                    
                    // Остаток товара
                    HStack {
                        Text("Осталось в наличии:")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text("\(product.items_left) шт.")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(product.items_left > 0 ? .green : .red)
                    }
                    
                    Divider()
                        .padding(.vertical, 8)
                    
                    // Описание (заглушка, так как в модели нет описания)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Описание")
                            .font(.system(size: 18, weight: .semibold))
                        
                        Text("Премиальный продукт от \(product.brand). \(product.product_name) - это качественный товар, который сочетает в себе стиль и функциональность.")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                            .lineSpacing(4)
                    }
                    .padding(.top, 8)
                }
                .padding(.horizontal)
                
                // Кнопка добавления в корзину
                if !product.isSoldOut {
                    Button(action: {
                        // Действие добавления в корзину
                        print("Добавить в корзину: \(product.product_name)")
                    }) {
                        HStack {
                            Spacer()
                            Text("Добавить в корзину")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding()
                        .background(Color.black)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                } else {
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
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.primary)
                }
            }
        }
    }
}

