//
//  InterestService.swift
//  Tea-machinov
//
//  Created by user on 04.12.2025.
//

import Foundation
import Combine

class InterestService: ObservableObject {
    @Published var selectedInterests: [Interest] = []
    
    let availableInterests: [Interest] = [
        Interest(title: "Running", imageName: "muzhik1", category: "Running"),
        Interest(title: "Training", imageName: "crossovki", category: "Training"),
        Interest(title: "Basketball", imageName: "crossovki2", category: "Basketball"),
        Interest(title: "Shoes", imageName: "crossovki3", category: "Shoes"),
        Interest(title: "Apparel", imageName: "crossovki4", category: "Apparel"),
        Interest(title: "Accessories", imageName: "food", category: "Accessories")
    ]
    
    init() {
        // Инициализируем с дефолтными интересами
        selectedInterests = Array(availableInterests.prefix(3))
    }
    
    func addInterest(_ interest: Interest) {
        if !selectedInterests.contains(where: { $0.id == interest.id }) {
            selectedInterests.append(interest)
        }
    }
    
    func removeInterest(_ interest: Interest) {
        selectedInterests.removeAll { $0.id == interest.id }
    }
    
    func getProductsByInterest(_ interest: Interest, from products: [Product]) -> [Product] {
        let interestCategory = interest.category.lowercased()
        return products.filter { product in
            let productName = product.product_name.lowercased()
            let brand = product.brand.lowercased()
            let category = product.category?.lowercased() ?? ""
            let combined = "\(productName) \(brand) \(category)".lowercased()
            
            return combined.contains(interestCategory) ||
                   productName.contains(interestCategory) ||
                   brand.contains(interestCategory) ||
                   category.contains(interestCategory)
        }
    }
}

