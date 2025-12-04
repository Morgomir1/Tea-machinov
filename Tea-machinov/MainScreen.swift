//
//  ContentView 2.swift
//  Tea-machinov
//
//  Created by user on 27.11.2025.
//

import SwiftUI // Импорт фреймворка SwiftUI для построения интерфейса

struct MainScreen: View { // Объявление структуры основного экрана, соответствующей протоколу View
    // Параметр для настройки размера шрифта (состояние, которое может меняться)
    @State private var titleFontSize: CGFloat = 30
    
    var body: some View { // Определение содержимого представления
        GeometryReader { geometry in // Контейнер для получения размеров экрана
            ZStack { // Контейнер для наложения слоёв (фоновое изображение, градиент, контент, кнопки)
                // Фоновое изображение
                Image("main_background")
                    .resizable() // Возможность изменять размер
                    .edgesIgnoringSafeArea(.all) // Игнорирование безопасных зон на весь экран
                
                // Градиентное затемнение снизу (от прозрачного к чёрному)
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.clear,
                        Color.black.opacity(1.0)
                    ]),
                    startPoint: .top, // Начало градиента сверху
                    endPoint: .bottom // Конец градиента снизу
                )
                .edgesIgnoringSafeArea(.all) // На весь экран
                
                VStack { // Вертикальный контейнер для основного контента
                    Spacer() // Гибкий пробел, чтобы контент сместился вниз
                    
                    // Плашка с контентом (теперь прозрачная)
                    VStack(spacing: 0) { // Вложенный вертикальный контейнер без промежутков
                        Image("nike_icon") // Логотип Nike
                            .resizable() // Изменяемый размер
                            .aspectRatio(contentMode: .fit) // Сохранять пропорции
                            .frame(width: 233, height: 132) // Фиксированный размер
                            .frame(maxWidth: .infinity, alignment: .leading) // Растягивание по ширине с выравниванием влево
                            .offset(x: -69) // Смещение влево для позиционирования
                        
                        Text("Nike App \nBringing Nike Member\nthe best products,\ninspiration and stories\nin sport.") // Многострочный текст
                            .font(.system(size: titleFontSize, weight: .bold)) // Жирный шрифт с изменяемым размером
                            .foregroundColor(.white) // Белый цвет текста
                            .multilineTextAlignment(.leading) // Выравнивание текста по левому краю
                            .frame(maxWidth: .infinity, alignment: .leading) // Растягивание на всю ширину
                            .padding(.vertical) // Вертикальные отступы
                    }
                    .padding(10) // Внутренние отступы
                    .background(Color.clear) // Прозрачный фон
                    .padding(.bottom, geometry.size.height * 0.25) // Нижний отступ 25% высоты экрана
                }
                
                // Контейнер для кнопок с позиционированием 15% от нижней границы
                VStack {
                    Spacer() // Гибкий пробел для прижатия кнопок к низу
                    
                    HStack(spacing: 16) { // Горизонтальный контейнер для кнопок с промежутком 16
                        // Кнопка Join Us
                        Button("Join Us") {
                            // Действие для Join Us (пока не реализовано)
                        }
                        .font(.headline) // Шрифт заголовка
                        .foregroundColor(.black) // Чёрный цвет текста
                        .frame(width: 158, height: 50) // Фиксированный размер
                        .background(Color.white) // Белый фон
                        .cornerRadius(50) // Полное скругление углов
                        
                        // Кнопка Sign In
                        Button("Sign In") {
                            // Действие для Sign In (пока не реализовано)
                        }
                        .font(.headline) // Шрифт заголовка
                        .foregroundColor(.white) // Белый цвет текста
                        .frame(width: 158, height: 50) // Фиксированный размер
                        .background(Color.clear) // Прозрачный фон
                        .overlay( // Наложение обводки
                            RoundedRectangle(cornerRadius: 50) // Прямоугольник со скруглёнными углами
                                .stroke(Color.white, lineWidth: 1) // Белая обводка толщиной 1
                        )
                    }
                    .padding(.bottom, geometry.size.height * 0.15) // Нижний отступ 15% высоты экрана
                }
                
                // Белый индикатор внизу экрана (закомментирован)
                //BottomIndicatorView()
            }
        }
        // Отображение статус-бара (по умолчанию false - отображается)
        .statusBar(hidden: false)
    }
}

// Расширение для скругления только определённых углов
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners)) // Обрезка по заданной форме
    }
}

// Кастомная форма для скругления конкретных углов
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity // Радиус скругления (по умолчанию максимальный)
    var corners: UIRectCorner = .allCorners // Какие углы скруглять (по умолчанию все)

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath) // Создание пути с заданными скруглениями
    }
}

#Preview {
    MainScreen() // Предпросмотр для Xcode
}
