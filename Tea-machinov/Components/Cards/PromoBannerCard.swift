import SwiftUI

// Промо-баннер с заголовком и подзаголовком
struct PromoBannerCard: View {
    let title: String
    let subtitle: String
    let imageName: String
    let height: CGFloat
    
    var body: some View {
        ZStack(alignment: .leading) {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: height)
                .clipped()
                .cornerRadius(12)
            
            LinearGradient(
                gradient: Gradient(colors: [Color.black.opacity(0.4), Color.clear]),
                startPoint: .leading,
                endPoint: .trailing
            )
            .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                Text(subtitle)
                    .font(.system(size: 16))
                    .foregroundColor(.white.opacity(0.9))
            }
            .padding(.leading, 20)
            .padding(.top, 20)
        }
    }
}
