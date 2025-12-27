import SwiftUI

// Карточка интереса пользователя - показывает категорию товаров
struct InterestCard: View {
    let title: String
    let imageName: String
    
    var body: some View {
        ZStack(alignment: .leading) {
            // Фоновое изображение
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 200, height: 150)
                .clipped()
                .cornerRadius(12)
            
            // Градиент снизу для читаемости текста
            LinearGradient(
                gradient: Gradient(colors: [Color.black.opacity(0.4), Color.clear]),
                startPoint: .bottom,
                endPoint: .top
            )
            .cornerRadius(12)
            
            // Название интереса внизу слева
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
                .padding(.leading, 16)
                .padding(.bottom, 16)
        }
        .frame(width: 200, height: 150)
    }
}

