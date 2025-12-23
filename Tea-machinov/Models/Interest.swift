//
//  Interest.swift
//  Tea-machinov
//
//  Created by user on 04.12.2025.
//

import Foundation

struct Interest: Identifiable, Hashable {
    let id: UUID
    let title: String
    let imageName: String
    let category: String
    
    init(id: UUID = UUID(), title: String, imageName: String, category: String) {
        self.id = id
        self.title = title
        self.imageName = imageName
        self.category = category
    }
}

