import SwiftUI

struct OnboardingScreen: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Фон
                Image("main_background")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                // Элемент с картинкой "crossovki" со скрученными краями (сдвинут направо)
                UIKitImageView()
                    .frame(width: 198, height: 302)
                    .position(
                        x: 186 + 198/2, // Сдвиг на 20 пунктов направо
                        y: 104 + 302/2
                    )
                
                // Новая картинка "tetka1" со скрученными краями
                Tetka1ImageView()
                    .frame(width: 142, height: 183)
                    .position(
                        x: 11 + 142/2,
                        y: 223 + 183/2
                    )
                
                // Новая картинка "tetka2" со скрученными краями (такая же ширина как tetka1)
                Tetka2ImageView()
                    .padding(16.0)
                    .frame(width: 100, height: 344) // Такая же ширина как tetka1
                    .position(
                        x: 11 + 142/2, // Такая же позиция X как у tetka1
                        y: 419 + 304/2 // Исходная позиция Y
                    )
                
                // ОБЩЕЕ ЗАТЕМНЕНИЕ всего экрана (менее темное)
                Color.black.opacity(0.2)
                    .edgesIgnoringSafeArea(.all)
                
                // Градиентное затемнение сверху и снизу для усиления эффекта
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: .black.opacity(0.4), location: 0.0),
                        .init(color: .clear, location: 0.3),
                        .init(color: .clear, location: 0.7),
                        .init(color: .black.opacity(0.4), location: 1.0)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                
                // Новый текст с атрибутами из UIKit кода
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
                
                // Кнопка Get Started
                Button(action: {
                    // Действие для кнопки
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
                
                // Индикатор вверху
                Rectangle()
                    .fill(Color(red: 0.322, green: 0.314, blue: 0.318))
                    .frame(width: 167, height: 4)
                    .cornerRadius(10)
                    .position(
                        x: 104 + 167/2,
                        y: 54 + 4/2
                    )
                
                // Новый элемент - белый индикатор внизу
                Rectangle()
                    .fill(Color.white)
                    .frame(width: 134, height: 5)
                    .cornerRadius(100)
                    .position(
                        x: geometry.size.width / 2 + 0.5,
                        y: geometry.size.height - 9 - 2.5
                    )
            }
        }
        .statusBar(hidden: false)
    }
}

// UIViewRepresentable для картинки "crossovki" со скрученными краями
struct UIKitImageView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 198, height: 302)
        
        let image0 = UIImage(named: "crossovki")?.cgImage
        let layer0 = CALayer()
        layer0.contents = image0
        layer0.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 1.11, b: 0, c: 0, d: 1, tx: -0.06, ty: 0))
        layer0.bounds = view.bounds
        layer0.position = view.center
        
        // Добавляем скрученные края с помощью маски
        let maskLayer = CAShapeLayer()
        let path = UIBezierPath()
        
        // Создаем путь со скрученными краями
        let width: CGFloat = 198
        let height: CGFloat = 302
        let curveAmount: CGFloat = 15 // Сила скручивания краев
        
        path.move(to: CGPoint(x: curveAmount, y: 0))
        path.addLine(to: CGPoint(x: width - curveAmount, y: 0))
        path.addQuadCurve(to: CGPoint(x: width, y: curveAmount), controlPoint: CGPoint(x: width, y: 0))
        path.addLine(to: CGPoint(x: width, y: height - curveAmount))
        path.addQuadCurve(to: CGPoint(x: width - curveAmount, y: height), controlPoint: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: curveAmount, y: height))
        path.addQuadCurve(to: CGPoint(x: 0, y: height - curveAmount), controlPoint: CGPoint(x: 0, y: height))
        path.addLine(to: CGPoint(x: 0, y: curveAmount))
        path.addQuadCurve(to: CGPoint(x: curveAmount, y: 0), controlPoint: CGPoint(x: 0, y: 0))
        path.close()
        
        maskLayer.path = path.cgPath
        layer0.mask = maskLayer
        
        view.layer.addSublayer(layer0)
        
        // Добавляем тень для лучшего визуального эффекта
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 0.3
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // Обновление view при необходимости
    }
}

// UIViewRepresentable для картинки "tetka1" со скрученными краями
struct Tetka1ImageView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 142, height: 183)
        
        let image0 = UIImage(named: "tetka1")?.cgImage
        let layer0 = CALayer()
        layer0.contents = image0
        layer0.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 1.03, b: 0, c: 0, d: 1, tx: -0.02, ty: 0))
        layer0.bounds = view.bounds
        layer0.position = view.center
        
        // Добавляем скрученные края с помощью маски (как у crossovki)
        let maskLayer = CAShapeLayer()
        let path = UIBezierPath()
        
        // Создаем путь со скрученными краями
        let width: CGFloat = 142
        let height: CGFloat = 183
        let curveAmount: CGFloat = 10 // Сила скручивания краев (немного меньше из-за меньшего размера)
        
        path.move(to: CGPoint(x: curveAmount, y: 0))
        path.addLine(to: CGPoint(x: width - curveAmount, y: 0))
        path.addQuadCurve(to: CGPoint(x: width, y: curveAmount), controlPoint: CGPoint(x: width, y: 0))
        path.addLine(to: CGPoint(x: width, y: height - curveAmount))
        path.addQuadCurve(to: CGPoint(x: width - curveAmount, y: height), controlPoint: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: curveAmount, y: height))
        path.addQuadCurve(to: CGPoint(x: 0, y: height - curveAmount), controlPoint: CGPoint(x: 0, y: height))
        path.addLine(to: CGPoint(x: 0, y: curveAmount))
        path.addQuadCurve(to: CGPoint(x: curveAmount, y: 0), controlPoint: CGPoint(x: 0, y: 0))
        path.close()
        
        maskLayer.path = path.cgPath
        layer0.mask = maskLayer
        
        view.layer.addSublayer(layer0)
        
        // Добавляем тень для лучшего визуального эффекта
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 6
        view.layer.shadowOpacity = 0.3
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // Обновление view при необходимости
    }
}

// UIViewRepresentable для картинки "tetka2" со скрученными краями
struct Tetka2ImageView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 142, height: 304) // Ширина уменьшена до 142 как у tetka1
        
        let image0 = UIImage(named: "tetka2")?.cgImage
        let layer0 = CALayer()
        layer0.contents = image0
        layer0.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 1.58, b: 0, c: 0, d: 1, tx: -0.29, ty: 0))
        layer0.bounds = view.bounds
        layer0.position = view.center
        
        // Добавляем скрученные края с помощью маски
        let maskLayer = CAShapeLayer()
        let path = UIBezierPath()
        
        // Создаем путь со скрученными краями
        let width: CGFloat = 142 // Ширина уменьшена до 142
        let height: CGFloat = 304
        let curveAmount: CGFloat = 10 // Сила скручивания краев (как у tetka1)
        
        path.move(to: CGPoint(x: curveAmount, y: 0))
        path.addLine(to: CGPoint(x: width - curveAmount, y: 0))
        path.addQuadCurve(to: CGPoint(x: width, y: curveAmount), controlPoint: CGPoint(x: width, y: 0))
        path.addLine(to: CGPoint(x: width, y: height - curveAmount))
        path.addQuadCurve(to: CGPoint(x: width - curveAmount, y: height), controlPoint: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: curveAmount, y: height))
        path.addQuadCurve(to: CGPoint(x: 0, y: height - curveAmount), controlPoint: CGPoint(x: 0, y: height))
        path.addLine(to: CGPoint(x: 0, y: curveAmount))
        path.addQuadCurve(to: CGPoint(x: curveAmount, y: 0), controlPoint: CGPoint(x: 0, y: 0))
        path.close()
        
        maskLayer.path = path.cgPath
        layer0.mask = maskLayer
        
        view.layer.addSublayer(layer0)
        
        // Добавляем тень для лучшего визуального эффекта
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 6
        view.layer.shadowOpacity = 0.3
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // Обновление view при необходимости
    }
}

#Preview {
    OnboardingScreen()
}
