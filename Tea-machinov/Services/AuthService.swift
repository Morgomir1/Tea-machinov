import Foundation
import Combine

// Сервис для управления авторизацией пользователя
class AuthService: ObservableObject {
    // Email авторизованного пользователя (nil если не авторизован)
    @Published var userEmail: String?
    
    // Проверяем, авторизован ли пользователь
    var isAuthenticated: Bool {
        userEmail != nil
    }
    
    init() {
        // При создании загружаем сохраненный email
        loadUserEmail()
    }
    
    // Авторизация пользователя (сохранение email)
    func signIn(email: String) {
        userEmail = email
        saveUserEmail()
    }
    
    // Выход из аккаунта
    func signOut() {
        userEmail = nil
        saveUserEmail()
    }
    
    // Сохраняем email в UserDefaults
    private func saveUserEmail() {
        if let email = userEmail {
            UserDefaults.standard.set(email, forKey: "userEmail")
        } else {
            UserDefaults.standard.removeObject(forKey: "userEmail")
        }
    }
    
    // Загружаем email из UserDefaults
    private func loadUserEmail() {
        userEmail = UserDefaults.standard.string(forKey: "userEmail")
    }
}

