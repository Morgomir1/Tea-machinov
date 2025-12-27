import SwiftUI

// Экран онбординга - первый экран после регистрации, показывает разные товары
struct OnboardingScreen: View {
    
    // Переход на главный экран с табами
    var goToTabs: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Темно-серый фон
                Color(red: 0.3, green: 0.3, blue: 0.3)
                    .edgesIgnoringSafeArea(.all)
                
                UIKitImageView()
                    .frame(width: 198, height: 302)
                    .position(
                        x: 186 + 178/2,
                        y: 104 + 302/2
                    )
                
                Tetka1ImageView()
                    .frame(width: 142, height: 183)
                    .position(
                        x: 11 + 142/2,
                        y: 223 + 183/2
                    )
                
                Tetka2ImageView()
                    .frame(width: 154, height: 304)
                    .position(
                        x: 0 + 154/2,
                        y: 419 + 304/2
                    )
                
                Muzhik1ImageView()
                    .frame(width: 144, height: 203)
                    .position(
                        x: 166 + 144/2,
                        y: 418 + 203/2
                    )
                
                Tetka3ImageView()
                    .frame(width: 209, height: 306)
                    .position(
                        x: 166 + 209/2,
                        y: 633 + 306/2
                    )
                
                FoodImageView()
                    .frame(width: 162, height: 203)
                    .position(
                        x: 322 + 162/2,
                        y: 418 + 203/2
                    )
                
                Crossovki2ImageView()
                    .frame(width: 199, height: 222)
                    .position(
                        x: -46 + 199/2,
                        y: 730 + 222/2
                    )
                
                Crossovki3ImageView()
                    .frame(width: 143, height: 210)
                    .position(
                        x: 11 + 143/2,
                        y: 0 + 210/2
                    )
                
                Crossovki4ImageView()
                    .frame(width: 208, height: 129)
                    .position(
                        x: 166 + 208/2,
                        y: -33 + 129/2
                    )
                
                // Градиент сверху для затемнения
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: .black.opacity(1.5), location: 0.0),
                        .init(color: .black.opacity(0.1), location: 0.5)
                    ]),
                    startPoint: .top,
                    endPoint: .center
                )
                .edgesIgnoringSafeArea(.all)
                
                // Градиент снизу для затемнения
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: .black.opacity(0.1), location: 0.5),
                        .init(color: .black.opacity(1.5), location: 1.0)
                    ]),
                    startPoint: .center,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                
                // Общее затемнение экрана
                Color.black.opacity(0.2)
                    .edgesIgnoringSafeArea(.all)
                
                // Текст приветствия
                Text("To personalize your\nexperience and \nconnect you to sport, we've got a few \nquestions for you.")
                    .font(.custom("Inter-SemiBold", size: 30))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .lineSpacing(30 * 0.07)
                    .tracking(-1.05)
                    .frame(width: 342, height: 195, alignment: .leading)
                    .position(
                        x: 24 + 342/2,
                        y: 88 + 195/2
                    )
                
                // Кнопка "Get Started" для перехода дальше
                Button(action: {
                    goToTabs()
                }) {
                    Text("Get Started")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .frame(width: 162, height: 49)
                        .background(Color.white)
                        .cornerRadius(50)
                }
                .position(
                    x: 107 + 81,
                    y: 711 + 24.5
                )
                
                // Индикатор прогресса (серый фон)
                Rectangle()
                    .fill(Color(red: 0.322, green: 0.314, blue: 0.318))
                    .frame(width: 167, height: 4)
                    .cornerRadius(10)
                    .position(
                        x: 104 + 167/2,
                        y: 54 + 4/2
                    )
                
                // Индикатор прогресса (белая часть)
                Rectangle()
                    .fill(Color.white)
                    .frame(width: 58, height: 4)
                    .cornerRadius(10)
                    .position(
                        x: 104 + 58/2,
                        y: 54 + 4/2
                    )
            }
        }
        .statusBar(hidden: false)
    }
}


#Preview {
    OnboardingScreen(goToTabs: {
        
    })
}
