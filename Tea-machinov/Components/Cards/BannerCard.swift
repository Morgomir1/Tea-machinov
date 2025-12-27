import SwiftUI

// Баннер-карточка с градиентом
struct BannerCard: View {
    let title: String
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
                gradient: Gradient(colors: [Color.black.opacity(0.3), Color.clear]),
                startPoint: .leading,
                endPoint: .trailing
            )
            .cornerRadius(12)
            
            Text(title)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
                .padding(.leading, 20)
                .padding(.top, 20)
        }
    }
}
