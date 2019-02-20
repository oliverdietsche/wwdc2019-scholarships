import SpriteKit

public struct GameData {    
    public init(width: Double, height: Double, layers: Int, pieces: Int) {
        self.width = width
        self.height = height
        self.center = CGPoint(x: self.width * 0.5, y: self.height * 0.5)
        
        self.layers = layers
        self.pieces = pieces
    }
    
    public let borderColor: SKColor = UIColor.black
    public let fillColor: SKColor = UIColor.lightGray
    public let centerColor: SKColor = UIColor.gray
    
    public let width: Double
    public let height: Double
    public let center: CGPoint
    
    public var layers: Int
    public var pieces: Int
    
    public var frame: CGRect {
        get {
            return CGRect(x: 0, y: 0, width: self.width, height: self.height)
        }
    }
    
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
