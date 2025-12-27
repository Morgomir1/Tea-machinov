import SwiftUI

// Экран онбординга - первый экран после регистрации, показывает разные товары
struct OnboardingScreen: View {
    
    // Переход на главный экран с табами
    var goToTabs: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Темно-серый фон
                Color(red: 0.3, green: 0.3, blue: 0.3)
                    .edgesIgnoringSafeArea(.all)
                
                UIKitImageView()
                    .frame(width: 198, height: 302)
                    .position(
                        x: 186 + 178/2,
                        y: 104 + 302/2
                    )
                
                Tetka1ImageView()
                    .frame(width: 142, height: 183)
                    .position(
                        x: 11 + 142/2,
                        y: 223 + 183/2
                    )
                
                Tetka2ImageView()
                    .frame(width: 154, height: 304)
                    .position(
                        x: 0 + 154/2,
                        y: 419 + 304/2
                    )
                
                Muzhik1ImageView()
                    .frame(width: 144, height: 203)
                    .position(
                        x: 166 + 144/2,
                        y: 418 + 203/2
                    )
                
                Tetka3ImageView()
                    .frame(width: 209, height: 306)
                    .position(
                        x: 166 + 209/2,
                        y: 633 + 306/2
                    )
                
                FoodImageView()
                    .frame(width: 162, height: 203)
                    .position(
                        x: 322 + 162/2,
                        y: 418 + 203/2
                    )
                
                Crossovki2ImageView()
                    .frame(width: 199, height: 222)
                    .position(
                        x: -46 + 199/2,
                        y: 730 + 222/2
                    )
                
                Crossovki3ImageView()
                    .frame(width: 143, height: 210)
                    .position(
                        x: 11 + 143/2,
                        y: 0 + 210/2
                    )
                
                Crossovki4ImageView()
                    .frame(width: 208, height: 129)
                    .position(
                        x: 166 + 208/2,
                        y: -33 + 129/2
                    )
                
                // Градиент сверху для затемнения
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: .black.opacity(1.5), location: 0.0),
                        .init(color: .black.opacity(0.1), location: 0.5)
                    ]),
                    startPoint: .top,
                    endPoint: .center
                )
                .edgesIgnoringSafeArea(.all)
                
                // Градиент снизу для затемнения
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: .black.opacity(0.1), location: 0.5),
                        .init(color: .black.opacity(1.5), location: 1.0)
                    ]),
                    startPoint: .center,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                
                // Общее затемнение экрана
                Color.black.opacity(0.2)
                    .edgesIgnoringSafeArea(.all)
                
                // Текст приветствия
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
                
                // Кнопка "Get Started" для перехода дальше
                Button(action: {
                    goToTabs()
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
                
                // Индикатор прогресса (серый фон)
                Rectangle()
                    .fill(Color(red: 0.322, green: 0.314, blue: 0.318))
                    .frame(width: 167, height: 4)
                    .cornerRadius(10)
                    .position(
                        x: 104 + 167/2,
                        y: 54 + 4/2
                    )
                
                // Индикатор прогресса (белая часть)
                Rectangle()
                    .fill(Color.white)
                    .frame(width: 58, height: 4)
                    .cornerRadius(10)
                    .position(
                        x: 104 + 58/2,
                        y: 54 + 4/2
                    )
            }
        }
        .statusBar(hidden: false)
    }
}

// UIViewRepresentable для изображения с скрученными краями (используем UIKit для сложных эффектов)
struct Tetka2ImageView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 154, height: 304)
        
        // Загружаем изображение и применяем трансформацию
        let image0 = UIImage(named: "tetka2")?.cgImage
        let layer0 = CALayer()
        layer0.contents = image0
        layer0.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 1.58, b: 0, c: 0, d: 1, tx: -0.29, ty: 0))
        layer0.bounds = view.bounds
        layer0.position = view.center
        
        // Создаем маску со скрученными краями для эффекта "рваных" краев
        let maskLayer = CAShapeLayer()
        let path = UIBezierPath()
        
        let width: CGFloat = 154
        let height: CGFloat = 304
        let curveAmount: CGFloat = 10 // Насколько скручиваем края
        
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
        
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 6
        view.layer.shadowOpacity = 0.3
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

struct Crossovki4ImageView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 208, height: 129)
        
        let image0 = UIImage(named: "crossovki4")?.cgImage
        let layer0 = CALayer()
        layer0.contents = image0
        layer0.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 1, b: 0, c: 0, d: 1.07, tx: 0, ty: -0.04))
        layer0.bounds = view.bounds
        layer0.position = view.center
        
        let maskLayer = CAShapeLayer()
        let path = UIBezierPath()
        
        let width: CGFloat = 208
        let height: CGFloat = 129
        let curveAmount: CGFloat = 10
        
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
        
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 6
        view.layer.shadowOpacity = 0.3
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

struct Crossovki3ImageView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 143, height: 210)
        
        let image0 = UIImage(named: "crossovki3")?.cgImage
        let layer0 = CALayer()
        layer0.contents = image0
        layer0.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 1, b: 0, c: 0, d: 1.02, tx: 0, ty: -0.01))
        layer0.bounds = view.bounds
        layer0.position = view.center
        
        // Добавляем скрученные края с помощью маски (как у других изображений)
        let maskLayer = CAShapeLayer()
        let path = UIBezierPath()
        
        // Создаем путь со скрученными краями
        let width: CGFloat = 143
        let height: CGFloat = 210
        let curveAmount: CGFloat = 10
        
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
        
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 6
        view.layer.shadowOpacity = 0.3
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

struct Crossovki2ImageView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 199, height: 222)
        
        let image0 = UIImage(named: "crossovki2")?.cgImage
        let layer0 = CALayer()
        layer0.contents = image0
        layer0.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 1, b: 0, c: 0, d: 1, tx: 0, ty: 0))
        layer0.bounds = view.bounds
        layer0.position = view.center
        
        // Добавляем скрученные края с помощью маски (как у других изображений)
        let maskLayer = CAShapeLayer()
        let path = UIBezierPath()
        
        // Создаем путь со скрученными краями
        let width: CGFloat = 199
        let height: CGFloat = 222
        let curveAmount: CGFloat = 12
        
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
        
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 0.3
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

struct FoodImageView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 162, height: 203)
        
        let image0 = UIImage(named: "food")?.cgImage
        let layer0 = CALayer()
        layer0.contents = image0
        layer0.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 1, b: 0, c: 0, d: 1, tx: 0, ty: 0))
        layer0.bounds = view.bounds
        layer0.position = view.center
        
        // Добавляем скрученные края с помощью маски (как у других изображений)
        let maskLayer = CAShapeLayer()
        let path = UIBezierPath()
        
        // Создаем путь со скрученными краями
        let width: CGFloat = 162
        let height: CGFloat = 203
        let curveAmount: CGFloat = 10
        
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
        
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 6
        view.layer.shadowOpacity = 0.3
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

struct Tetka3ImageView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 209, height: 306)
        
        let image0 = UIImage(named: "tetka3")?.cgImage
        let layer0 = CALayer()
        layer0.contents = image0
        layer0.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 1, b: 0, c: 0, d: 1.02, tx: 0, ty: -0.01))
        layer0.bounds = view.bounds
        layer0.position = view.center
        view.layer.addSublayer(layer0)
        
        let maskLayer = CAShapeLayer()
        let path = UIBezierPath()
        
        let width: CGFloat = 209
        let height: CGFloat = 306
        let curveAmount: CGFloat = 12
        
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
        
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 0.3
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

struct Muzhik1ImageView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 144, height: 203)
        
        let image0 = UIImage(named: "muzhik1")?.cgImage
        let layer0 = CALayer()
        layer0.contents = image0
        layer0.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 1.13, b: 0, c: 0, d: 1, tx: -0.06, ty: 0))
        layer0.bounds = view.bounds
        layer0.position = view.center
        view.layer.addSublayer(layer0)
        
        let maskLayer = CAShapeLayer()
        let path = UIBezierPath()
        
        let width: CGFloat = 144
        let height: CGFloat = 203
        let curveAmount: CGFloat = 10
        
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
        
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 6
        view.layer.shadowOpacity = 0.3
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

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
        
        let maskLayer = CAShapeLayer()
        let path = UIBezierPath()
        
        let width: CGFloat = 198
        let height: CGFloat = 302
        let curveAmount: CGFloat = 15
        
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
    }
}

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
        
        let maskLayer = CAShapeLayer()
        let path = UIBezierPath()
        
        let width: CGFloat = 142
        let height: CGFloat = 183
        let curveAmount: CGFloat = 10
        
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
    }
}

#Preview {
    OnboardingScreen(goToTabs: {
        
    })
}
