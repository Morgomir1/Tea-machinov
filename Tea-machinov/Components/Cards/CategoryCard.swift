import SwiftUI

// Карточка категории товаров
struct CategoryCard: View {
    let title: String
    let imageName: String
    let height: CGFloat
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            GeometryReader { geometry in
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: height)
                    .clipped()
            }
            .frame(height: height)
            .cornerRadius(12)
            
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .padding(.top, 8)
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity)
    }
}
