import SwiftUI

// Bottom sheet версия экрана авторизации с вводом email
struct EmailAuthBottomSheet: View {
    // Сервис авторизации
    @ObservedObject var authService: AuthService
    // Email адрес пользователя
    @State private var email: String = ""
    // Флаг для отображения ошибки валидации
    @State private var showError: Bool = false
    // Фокус на поле ввода
    @FocusState private var isEmailFocused: Bool
    // Переход в приложение после успешной авторизации
    var onSuccess: () -> Void
    // Закрытие bottom sheet
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                // Белый фон
                Color.white
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    // Логотип Nike - как на макете (черный swoosh вверху)
                    HStack {
                        Spacer()
                        Image("nike_icon")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 70, height: 40)
                            .foregroundColor(.black)
                        Spacer()
                    }
                    .padding(.top, 16)
                    .padding(.bottom, 28)
                    
                    // Заголовок
                    Text("Enter your email to join us or sign in.")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 32)
                    
                    // Выбор страны
                    HStack {
                        Text("United States")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                        Spacer()
                        Button("Change") {
                            // Здесь можно добавить выбор страны
                        }
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 16)
                    
                    // Поле ввода email
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Email")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        
                        TextField("", text: $email)
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .autocorrectionDisabled()
                            .focused($isEmailFocused)
                            .onChange(of: email) { newValue in
                                // Сбрасываем ошибку при изменении текста
                                if showError {
                                    showError = false
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(showError ? Color.red : Color.gray.opacity(0.3), lineWidth: 1)
                            )
                            .cornerRadius(4)
                        
                        // Сообщение об ошибке
                        if showError {
                            Text("Invalid email address")
                                .font(.system(size: 14))
                                .foregroundColor(.red)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)
                    
                    Spacer()
                    
                    // Кнопка продолжения
                    Button(action: {
                        if isValidEmail(email) {
                            // Сохраняем email в сервисе авторизации
                            authService.signIn(email: email)
                            // Закрываем bottom sheet и переходим в приложение
                            dismiss()
                            onSuccess()
                        } else {
                            // Показываем ошибку
                            showError = true
                        }
                    }) {
                        Text("Continue")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(isValidEmail(email) ? Color.black : Color.gray)
                            .cornerRadius(25)
                    }
                    .disabled(!isValidEmail(email))
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            // Автоматически фокусируемся на поле ввода
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isEmailFocused = true
            }
        }
    }
    
    // Функция валидации email
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}

#Preview {
    EmailAuthBottomSheet(
        authService: AuthService(),
        onSuccess: {
            
        }
    )
}

