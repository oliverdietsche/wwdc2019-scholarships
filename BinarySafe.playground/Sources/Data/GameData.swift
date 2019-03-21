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
    
    public var width: Double
    public var height: Double
    public var layers: Int
    public var pieces: Int
    
    public var titleSize: CGSize {
        get {
            var height: Double
            var width: Double
            if self.width > self.height {
                width = self.width * 0.5 - 10
            } else {
                width = self.width - 20
            }
            height = width * 0.2
            return CGSize(width: width, height: height)
        }
    }
    
    public var menuButtonSize: CGSize {
        get {
            var height: Double
            var width: Double
            if self.width > self.height {
                width = self.width * 0.25 - 15
            } else {
                width = self.width * 0.5 - 15
            }
            height = width * 0.33
            
            return CGSize(width: width, height: height)
        }
    }
    
    public var imageSize: CGSize {
        get {
            var height: Double
            if self.width > 700 {
                height = self.height * 0.5
            } else {
                height = self.height * 0.3
            }
            let width = height * 0.8125
            
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
