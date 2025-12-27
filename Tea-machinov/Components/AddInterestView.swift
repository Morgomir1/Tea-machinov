import SwiftUI

// Модальное окно для добавления новых интересов
struct AddInterestView: View {
    @ObservedObject var interestService: InterestService
    @Environment(\.dismiss) var dismiss
    
    // Показываем только те интересы, которые еще не добавлены
    var availableToAdd: [Interest] {
        interestService.availableInterests.filter { interest in
            !interestService.selectedInterests.contains { $0.id == interest.id }
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Выберите интересы")
                        .font(.system(size: 20, weight: .bold))
                        .padding(.horizontal)
                        .padding(.top)
                    
                    if availableToAdd.isEmpty {
                        // Если все интересы уже добавлены - показываем сообщение
                        VStack(spacing: 16) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.green)
                            Text("Все доступные интересы уже добавлены")
                                .font(.system(size: 16))
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 60)
                    } else {
                        // Сетка доступных интересов 2x2
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 12),
                            GridItem(.flexible(), spacing: 12)
                        ], spacing: 16) {
                            ForEach(availableToAdd) { interest in
                                // При нажатии добавляем интерес
                                Button(action: {
                                    interestService.addInterest(interest)
                                }) {
                                    VStack(spacing: 8) {
                                        Image(interest.imageName)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(height: 120)
                                            .clipped()
                                            .cornerRadius(12)
                                        
                                        Text(interest.title)
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(.primary)
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Добавить интерес")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Готово") {
                        dismiss()
                    }
                }
            }
        }
    }
}

