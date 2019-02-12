import SpriteKit

public struct GameData {    
    public init(width: Double, height: Double, layers: Int, pieces: Int, borderColor: SKColor, fillColor: SKColor, centerColor: SKColor) {
        self.width = width
        self.height = height
        self.center = CGPoint(x: self.width * 0.5, y: self.height * 0.5)
        
        self.layers = layers
        self.pieces = pieces
        self.borderColor = borderColor
        self.fillColor = fillColor
        self.centerColor = centerColor
    }
    
    public func newMenuScene() -> MenuScene {
        return MenuScene(self)
    }
    
    public func newGameScene() -> GameScene {
        return GameScene(self)
    }
    
    public let width: Double
    public let height: Double
    public let center: CGPoint
    
    public let borderColor: SKColor
    public let fillColor: SKColor
    public let centerColor: SKColor
    
    public var layers: Int
    public var pieces: Int
    
    public var degreeRange: Double {
        get {
            return GeometryData.fullDegreeOfCircle / Double(self.pieces)
        }
    }
    public var radianRange: CGFloat {
        get {
            return CGFloat(GeometryData.fullRadianOfCircle / CGFloat(self.pieces))
        }
    }
    public var innerRadius: Double {
        get {
            if width > height {
                return Double(self.height * 0.5) / Double(self.layers + 3)
            } else {
                return Double(self.width * 0.5) / Double(self.layers + 3)
            }
        }
    }
}
