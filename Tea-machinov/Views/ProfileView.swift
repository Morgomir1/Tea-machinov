import SwiftUI

// Экран профиля пользователя с заглушкой и кнопками авторизации
struct ProfileView: View {
    // Сервис авторизации
    @ObservedObject var authService: AuthService
    // Callback для перехода на экран авторизации (onboarding)
    var goToOnboarding: (() -> Void)?
    // Флаг для показа bottom sheet авторизации
    @State private var showAuthSheet = false
    
    init(authService: AuthService, goToOnboarding: (() -> Void)? = nil) {
        self.authService = authService
        self.goToOnboarding = goToOnboarding
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView {
                    VStack(spacing: 0) {
                        imagesGrid(geometry: geometry)
                        welcomeSection
                        Spacer()
                            .frame(height: 40)
                        authButtons
                    }
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
        }
        .navigationViewStyle(.stack)
        .sheet(isPresented: $showAuthSheet) {
            EmailAuthBottomSheet(
                authService: authService,
                onSuccess: {
                    // После успешной авторизации состояние профиля обновится автоматически
                    // через @ObservedObject authService
                }
            )
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
        }
    }
    
    private func imagesGrid(geometry: GeometryProxy) -> some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 12),
            GridItem(.flexible(), spacing: 12)
        ], spacing: 12) {
            Image("tetka1")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: (geometry.size.width - 48) / 2)
                .clipped()
                .cornerRadius(12)
            
            Image("muzhik1")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: (geometry.size.width - 48) / 2)
                .clipped()
                .cornerRadius(12)
            
            Image("tetka2")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: (geometry.size.width - 48) / 2)
                .clipped()
                .cornerRadius(12)
            
            Image("tetka3")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: (geometry.size.width - 48) / 2)
                .clipped()
                .cornerRadius(12)
        }
        .padding(.horizontal, 16)
        .padding(.top, 24)
    }
    
    private var welcomeSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Welcome to the")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(.primary)
            
            Text("Nike App")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
        .padding(.top, 32)
    }
    
    private var authButtons: some View {
        VStack(spacing: 16) {
            if authService.isAuthenticated {
                // Если пользователь авторизован, показываем email и кнопку Log Out
                VStack(spacing: 12) {
                    // Email пользователя
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Signed in as")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        Text(authService.userEmail ?? "")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.primary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Кнопка "Log Out"
                    Button("Log Out") {
                        authService.signOut()
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.black)
                    .cornerRadius(25)
                }
            } else {
                // Если пользователь не авторизован, показываем кнопку "Sign In"
                Button("Sign In") {
                    showAuthSheet = true
                }
                .font(.headline)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 50)
                        .stroke(Color.black, lineWidth: 1)
                )
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 40)
    }
}
