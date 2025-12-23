//
//  ProductGridCard.swift
//  Tea-machinov
//
//  Created by user on 04.12.2025.
//

import SwiftUI

struct ProductGridCard: View {
    let product: Product
    let onLikeToggle: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topTrailing) {
                AsyncImage(url: URL(string: product.image_url)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .overlay(
                            ProgressView()
                        )
                }
                .frame(height: 180)
                .clipped()
                .cornerRadius(12)
                
                // Иконка избранного
                Button(action: onLikeToggle) {
                    Image(systemName: product.is_liked ? "heart.fill" : "heart")
                        .foregroundColor(product.is_liked ? .red : .white)
                        .font(.system(size: 16))
                        .padding(8)
                        .background(Color.black.opacity(0.1))
                        .clipShape(Circle())
                }
                .padding(8)
            }
            
            // Бейдж Bestseller или Sold Out
            if product.is_bestseller {
                Text("Bestseller")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(.black)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.yellow)
                    .cornerRadius(4)
            } else if product.isSoldOut {
                Text("Sold Out")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.orange)
                    .cornerRadius(4)
            }
            
            // Название бренда
            Text(product.brand)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.primary)
                .lineLimit(1)
            
            // Название продукта
            Text(product.product_name)
                .font(.system(size: 12))
                .foregroundColor(.secondary)
                .lineLimit(2)
            
            // Количество цветов (извлекаем из названия, если есть)
            if product.product_name.contains("Colour") || product.product_name.contains("Colours") {
                let colorsText = extractColorsCount(from: product.product_name)
                if !colorsText.isEmpty {
                    Text(colorsText)
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                }
            }
            
            // Цена
            Text(product.formattedPrice)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func extractColorsCount(from text: String) -> String {
        // Извлекаем количество цветов из текста типа "3 Colours" или "5 Colours"
        if let range = text.range(of: #"\d+\s+Colou?rs?"#, options: .regularExpression) {
            return String(text[range])
        }
        return ""
    }
}

