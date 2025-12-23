//
//  CartItem.swift
//  Tea-machinov
//
//  Created by user on 04.12.2025.
//

import Foundation

struct CartItem: Identifiable {
    let id: UUID
    let product: Product
    var quantity: Int
    
    init(product: Product, quantity: Int = 1) {
        self.id = UUID()
        self.product = product
        self.quantity = quantity
    }
    
    var totalPrice: Double {
        product.price * Double(quantity)
    }
    
    var formattedTotalPrice: String {
        String(format: "US$%.2f", totalPrice)
    }
}

