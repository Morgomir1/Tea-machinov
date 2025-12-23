//
//  InterestCard.swift
//  Tea-machinov
//
//  Created by user on 04.12.2025.
//

import SwiftUI

struct InterestCard: View {
    let title: String
    let imageName: String
    
    var body: some View {
        ZStack(alignment: .leading) {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 200, height: 150)
                .clipped()
                .cornerRadius(12)
            
            // Градиент для лучшей читаемости текста
            LinearGradient(
                gradient: Gradient(colors: [Color.black.opacity(0.4), Color.clear]),
                startPoint: .bottom,
                endPoint: .top
            )
            .cornerRadius(12)
            
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
                .padding(.leading, 16)
                .padding(.bottom, 16)
        }
        .frame(width: 200, height: 150)
    }
}

