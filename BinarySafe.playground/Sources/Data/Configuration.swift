import SpriteKit

struct Color {
    static let border: SKColor = SKColor.black
    static let arrow: SKColor = SKColor.black
    static let fill: SKColor = SKColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1)
    static let center: SKColor = SKColor(red: 0.50, green: 0.50, blue: 0.50, alpha: 1)
    static let highlighted: SKColor = SKColor(red: 0.69, green: 0.99, blue: 1.00, alpha: 1.0)
}

struct FontSize {
    static let small: CGFloat = 20
    static let medium: CGFloat = 25
    static let large: CGFloat = 30
}

struct Size {
    static let gameButton: CGSize = CGSize(width: 60, height: 60)
}

struct Config {
    static let layersMinValue: Float = 2
    static let layersMaxValue: Float = 6
    static let piecesMinValue: Float = 3
    static let piecesMaxValue: Float = 10
}
