import SwiftUI

// Общий компонент для изображений с округленными краями в онбординге
struct RoundedImageView: UIViewRepresentable {
    let imageName: String
    let width: CGFloat
    let height: CGFloat
    let transform: CGAffineTransform
    let curveAmount: CGFloat
    let cornerRadius: CGFloat
    
    init(
        imageName: String,
        width: CGFloat,
        height: CGFloat,
        transform: CGAffineTransform = .identity,
        curveAmount: CGFloat = 10,
        cornerRadius: CGFloat = 8
    ) {
        self.imageName = imageName
        self.width = width
        self.height = height
        self.transform = transform
        self.curveAmount = curveAmount
        self.cornerRadius = cornerRadius
    }
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        let image0 = UIImage(named: imageName)?.cgImage
        let layer0 = CALayer()
        layer0.contents = image0
        layer0.transform = CATransform3DMakeAffineTransform(transform)
        layer0.bounds = view.bounds
        layer0.position = view.center
        
        // Создаем маску со скрученными краями
        let maskLayer = CAShapeLayer()
        let path = UIBezierPath()
        
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
        
        view.layer.cornerRadius = cornerRadius
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

// Специализированные компоненты для каждого изображения
struct UIKitImageView: View {
    var body: some View {
        RoundedImageView(
            imageName: "crossovki",
            width: 198,
            height: 302,
            transform: CGAffineTransform(a: 1.11, b: 0, c: 0, d: 1, tx: -0.06, ty: 0),
            curveAmount: 15,
            cornerRadius: 8
        )
    }
}

struct Tetka1ImageView: View {
    var body: some View {
        RoundedImageView(
            imageName: "tetka1",
            width: 142,
            height: 183,
            transform: CGAffineTransform(a: 1.03, b: 0, c: 0, d: 1, tx: -0.02, ty: 0),
            curveAmount: 10,
            cornerRadius: 8
        )
    }
}

struct Tetka2ImageView: View {
    var body: some View {
        RoundedImageView(
            imageName: "tetka2",
            width: 154,
            height: 304,
            transform: CGAffineTransform(a: 1.58, b: 0, c: 0, d: 1, tx: -0.29, ty: 0),
            curveAmount: 10,
            cornerRadius: 8
        )
    }
}

struct Tetka3ImageView: View {
    var body: some View {
        RoundedImageView(
            imageName: "tetka3",
            width: 209,
            height: 306,
            transform: CGAffineTransform(a: 1, b: 0, c: 0, d: 1.02, tx: 0, ty: -0.01),
            curveAmount: 12,
            cornerRadius: 8
        )
    }
}

struct Muzhik1ImageView: View {
    var body: some View {
        RoundedImageView(
            imageName: "muzhik1",
            width: 144,
            height: 203,
            transform: CGAffineTransform(a: 1.13, b: 0, c: 0, d: 1, tx: -0.06, ty: 0),
            curveAmount: 10,
            cornerRadius: 8
        )
    }
}

struct FoodImageView: View {
    var body: some View {
        RoundedImageView(
            imageName: "food",
            width: 162,
            height: 203,
            transform: .identity,
            curveAmount: 10,
            cornerRadius: 8
        )
    }
}

struct Crossovki2ImageView: View {
    var body: some View {
        RoundedImageView(
            imageName: "crossovki2",
            width: 199,
            height: 222,
            transform: .identity,
            curveAmount: 12,
            cornerRadius: 8
        )
    }
}

struct Crossovki3ImageView: View {
    var body: some View {
        RoundedImageView(
            imageName: "crossovki3",
            width: 143,
            height: 210,
            transform: CGAffineTransform(a: 1, b: 0, c: 0, d: 1.02, tx: 0, ty: -0.01),
            curveAmount: 10,
            cornerRadius: 10
        )
    }
}

struct Crossovki4ImageView: View {
    var body: some View {
        RoundedImageView(
            imageName: "crossovki4",
            width: 208,
            height: 129,
            transform: CGAffineTransform(a: 1, b: 0, c: 0, d: 1.07, tx: 0, ty: -0.04),
            curveAmount: 10,
            cornerRadius: 8
        )
    }
}
