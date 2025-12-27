import SwiftUI

// Экран профиля пользователя с заглушкой и кнопками авторизации
struct ProfileView: View {
    // Callback для перехода на экран авторизации (onboarding)
    var goToOnboarding: (() -> Void)?
    
    init(goToOnboarding: (() -> Void)? = nil) {
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
        HStack(spacing: 16) {
            // Кнопка "Join Us" - белая с черным текстом
            Button("Join Us") {
                goToOnboarding?()
            }
            .font(.headline)
            .foregroundColor(.black)
            .frame(width: 158, height: 50)
            .background(Color.white)
            .cornerRadius(50)
            .overlay(
                RoundedRectangle(cornerRadius: 50)
                    .stroke(Color.black.opacity(0.1), lineWidth: 1)
            )
            
            // Кнопка "Sign In" - прозрачная с черной обводкой
            Button("Sign In") {
                goToOnboarding?()
            }
            .font(.headline)
            .foregroundColor(.black)
            .frame(width: 158, height: 50)
            .background(Color.clear)
            .overlay(
                RoundedRectangle(cornerRadius: 50)
                    .stroke(Color.black, lineWidth: 1)
            )
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 40)
    }
}
