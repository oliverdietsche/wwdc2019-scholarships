import SpriteKit

struct Color {
    static let border: SKColor = SKColor.black
    static let arrow: SKColor = SKColor.black
    static let fill: SKColor = SKColor(displayP3Red: 0.85, green: 0.85, blue: 0.85, alpha: 1)
    static let center: SKColor = SKColor(displayP3Red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
}

struct FontSize {
    static let small: CGFloat = 20
    static let medium: CGFloat = 25
    static let large: CGFloat = 30
}

struct Size {
    static let gameButton: CGSize = CGSize(width: 60, height: 60)
}
