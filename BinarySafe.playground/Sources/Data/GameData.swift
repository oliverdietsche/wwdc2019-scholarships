import SpriteKit

public struct GameData {    
    public init() {
        self.width = 0
        self.height = 0
        self.layers = 3
        self.pieces = 4
    }
    
    public let borderColor: SKColor = UIColor.black
    public let fillColor: SKColor = UIColor.lightGray
    public let centerColor: SKColor = UIColor.gray
    
    public var width: Double
    public var height: Double
    public var layers: Int
    public var pieces: Int
    
    public var lineWidth: CGFloat {
        get {
            return CGFloat(self.innerRadius * 0.05)
        }
    }
    
    public var fontSize: CGFloat {
        get {
            return CGFloat(self.innerRadius * 0.8)
        }
    }
    
    public var center: CGPoint {
        get {
            return CGPoint(x: self.width * 0.5, y: self.height * 0.5)
        }
    }
    
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
