//
//  Product.swift
//  Tea-machinov
//
//  Created by user on 04.12.2025.
//

import Foundation

struct Product: Codable, Identifiable {
    let id: UUID
    let brand: String
    let product_name: String
    let price: Double
    let items_left: Int
    let image_url: String
    var is_liked: Bool
    let is_bestseller: Bool
    
    enum CodingKeys: String, CodingKey {
        case brand
        case product_name
        case price
        case items_left
        case image_url
        case is_liked
        case is_bestseller
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.brand = try container.decode(String.self, forKey: .brand)
        self.product_name = try container.decode(String.self, forKey: .product_name)
        self.price = try container.decode(Double.self, forKey: .price)
        self.items_left = try container.decode(Int.self, forKey: .items_left)
        self.image_url = try container.decode(String.self, forKey: .image_url)
        self.is_liked = try container.decode(Bool.self, forKey: .is_liked)
        self.is_bestseller = try container.decode(Bool.self, forKey: .is_bestseller)
    }
    
    init(id: UUID = UUID(), brand: String, product_name: String, price: Double, items_left: Int, image_url: String, is_liked: Bool, is_bestseller: Bool) {
        self.id = id
        self.brand = brand
        self.product_name = product_name
        self.price = price
        self.items_left = items_left
        self.image_url = image_url
        self.is_liked = is_liked
        self.is_bestseller = is_bestseller
    }
    
    var isSoldOut: Bool {
        items_left == 0
    }
    
    var formattedPrice: String {
        String(format: "US$%.2f", price)
    }
}

