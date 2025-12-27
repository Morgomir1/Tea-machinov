import SwiftUI

// Экран фильтров для товаров (пока только UI, логика фильтрации не реализована)
struct FilterView: View {
    @Environment(\.dismiss) var dismiss
    // Минимальная и максимальная цена
    @State private var minPrice: Double = 0
    @State private var maxPrice: Double = 500
    // Выбранные бренды
    @State private var selectedBrands: Set<String> = []
    @State private var showOnlyBestsellers = false
    @State private var showOnlyInStock = false
    
    // Список доступных брендов
    let brands = ["Nike", "Jordan Essentials", "Nike Sportswear Club", "Nike Elite Pro", "Nike Therma", "Nike Heritage"]
    
    var body: some View {
        NavigationView {
            Form {
                // Секция с фильтром по цене
                Section("Цена") {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("От: US$\(Int(minPrice))")
                            Spacer()
                            Text("До: US$\(Int(maxPrice))")
                        }
                        .font(.system(size: 14))
                        
                        // Два слайдера для выбора диапазона цен
                        HStack {
                            Slider(value: $minPrice, in: 0...500, step: 10)
                            Slider(value: $maxPrice, in: 0...500, step: 10)
                        }
                    }
                }
                
                // Секция с выбором брендов
                Section("Бренды") {
                    ForEach(brands, id: \.self) { brand in
                        // Переключатель для каждого бренда
                        Toggle(brand, isOn: Binding(
                            get: { selectedBrands.contains(brand) },
                            set: { isOn in
                                if isOn {
                                    selectedBrands.insert(brand)
                                } else {
                                    selectedBrands.remove(brand)
                                }
                            }
                        ))
                    }
                }
                
                // Дополнительные фильтры
                Section("Дополнительно") {
                    Toggle("Только бестселлеры", isOn: $showOnlyBestsellers)
                    Toggle("Только в наличии", isOn: $showOnlyInStock)
                }
                
                // Кнопка сброса всех фильтров
                Section {
                    Button("Сбросить фильтры") {
                        minPrice = 0
                        maxPrice = 500
                        selectedBrands.removeAll()
                        showOnlyBestsellers = false
                        showOnlyInStock = false
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("Фильтры")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Отмена") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Применить") {
                        // TODO: здесь должна быть логика применения фильтров
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

