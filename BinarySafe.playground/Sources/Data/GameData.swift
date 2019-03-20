import SpriteKit

// It stores all the relevant data for an instance of a game
public struct GameData {    
    public init() {
        // Default initialation
        self.width = 600
        self.height = 400
        
        // Beginning amount
        self.layers = 3
        self.pieces = 4
    }
    
    public let borderColor: SKColor = UIColor.black
    public let arrowColor: SKColor = UIColor.black
    public let fillColor: SKColor = UIColor(displayP3Red: 0.85, green: 0.85, blue: 0.85, alpha: 1)
    public let centerColor: SKColor = UIColor(displayP3Red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
    
    public let fontSizeSmall: CGFloat = 20
    public let fontSizeMedium: CGFloat = 25
    public let fontSizeLarge: CGFloat = 30
    public let gameButtonHeight: CGFloat = 60
    
    public var width: Double
    public var height: Double
    public var layers: Int
    public var pieces: Int
    
    public var titleSize: CGSize {
        get {
            return CGSize(width: self.width * 0.9, height: self.width * 0.18)
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
    
    public var innerRadius: Double {
        get {
            if width > height {
                return Double(self.height * 0.5) / Double(self.layers + 3)
            } else {
                return Double(self.width * 0.5) / Double(self.layers + 3)
            }
        }
    }
    
    public var lineWidth: CGFloat {
        get {
            return CGFloat(self.innerRadius * 0.1)
        }
    }
    
    public var circleFontSize: CGFloat {
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
}
