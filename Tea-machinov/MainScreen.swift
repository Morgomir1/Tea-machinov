import SwiftUI

// Главный экран приложения с приветствием и кнопками входа
struct MainScreen: View {
    // Размер шрифта для заголовка (можно менять если нужно)
    @State private var titleFontSize: CGFloat = 30
    // Сервис авторизации
    @ObservedObject var authService: AuthService
    // Переход на экран онбординга
    var goToOnboarding: () -> Void
    // Переход в приложение после успешной авторизации
    var onSignInSuccess: () -> Void
    // Флаг для показа bottom sheet авторизации
    @State private var showAuthSheet = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Фоновое изображение
                Image("main_background")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                
                // Градиент для затемнения снизу, чтобы текст был читаемым
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.clear,
                        Color.black.opacity(1.0)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                
                // Контент внизу экрана
                VStack {
                    Spacer()
                    
                    VStack(spacing: 0) {
                        // Логотип Nike
                        Image("nike_icon")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 233, height: 132)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .offset(x: -69) // Сдвигаем немного влево для позиционирования
                        
                        // Текст приветствия
                        Text("Nike App \nBringing Nike Member\nthe best products,\ninspiration and stories\nin sport.")
                            .font(.system(size: titleFontSize, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical)
                    }
                    .padding(10)
                    .background(Color.clear)
                    // Отступ снизу 25% от высоты экрана
                    .padding(.bottom, geometry.size.height * 0.25)
                }
                
                // Кнопки внизу экрана
                VStack {
                    Spacer()
                    
                    HStack(spacing: 16) {
                        // Кнопка "Join Us" - белая с черным текстом
                        Button("Join Us") {
                            goToOnboarding()
                        }
                        .font(.headline)
                        .foregroundColor(.black)
                        .frame(width: 158, height: 50)
                        .background(Color.white)
                        .cornerRadius(50)
                        
                        // Кнопка "Sign In" - прозрачная с белой обводкой
                        Button("Sign In") {
                            showAuthSheet = true
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 158, height: 50)
                        .background(Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(Color.white, lineWidth: 1)
                        )
                    }
                    // Отступ снизу 15% от высоты экрана
                    .padding(.bottom, geometry.size.height * 0.15)
                }
            }
        }
        .statusBar(hidden: false)
        .sheet(isPresented: $showAuthSheet) {
            EmailAuthBottomSheet(
                authService: authService,
                onSuccess: {
                    // После успешной авторизации переходим в приложение
                    onSignInSuccess()
                }
            )
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
        }
    }
}

// Расширение для скругления только определенных углов (пока не используется, но может пригодиться)
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

// Кастомная форма для скругления конкретных углов
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

#Preview {
    MainScreen(
        authService: AuthService(),
        goToOnboarding: {
            
        },
        onSignInSuccess: {
            
        }
    )
}
