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
        // Сначала фильтруем по основной категории
        var products = productService.products
        if categoryName == "Best Sellers" {
            products = productService.getBestsellers()
        }
        
        // Затем фильтруем по выбранной подкатегории
        return products.filter { product in
            matchesSubCategory(product: product, subCategory: selectedSubCategory)
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

