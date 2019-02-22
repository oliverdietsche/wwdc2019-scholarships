import SpriteKit

public struct GameData {    
    public init() {
        self.width = 400
        self.height = 600
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
    
    public var gameButtonLength: CGFloat {
        get {
            return CGFloat(self.innerRadius * 2)
        }
    }
    
    public var menuButtonSize: CGSize {
        get {
            var height = (self.width * 0.5 - 15) * 0.33
            if height > self.height * 0.25 {
                height = self.height * 0.25 - 20
            }
            let width = height * 3
            return CGSize(width: width, height: height)
        }
    }
    
    public var lineWidth: CGFloat {
        get {
            return CGFloat(self.innerRadius * 0.1)
        }
    }
    
    public var fontSize_s: CGFloat {
        get {
            return CGFloat(self.innerRadius * 0.6)
        }
    }
    
    public var fontSize_m: CGFloat {
        get {
            return CGFloat(self.innerRadius * 0.8)
        }
    }
    
    public var fontSize_l: CGFloat {
        get {
            return CGFloat(self.innerRadius)
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
