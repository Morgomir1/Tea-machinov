import SwiftUI

// Экран профиля пользователя с заглушкой и кнопками авторизации
struct ProfileView: View {
    // Callback для перехода на экран авторизации (onboarding)
    var goToOnboarding: (() -> Void)?
    // Флаг для показа bottom sheet авторизации
    @State private var showAuthSheet = false
    
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
        .sheet(isPresented: $showAuthSheet) {
            EmailAuthBottomSheet(onSuccess: {
                // После успешной авторизации можно выполнить дополнительные действия
                // Например, обновить состояние профиля
            })
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
        // Кнопка "Sign In" - на всю ширину
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
        .padding(.horizontal, 16)
        .padding(.bottom, 40)
    }
}
