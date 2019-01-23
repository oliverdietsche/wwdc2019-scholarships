import SpriteKit

extension Double {
    public var toDegrees: Double { return self * 180 / Double.pi }
    public var toRadians: Double { return self * Double.pi / 180 }
}

extension CGFloat {
    public var toDegrees: CGFloat { return self * 180 / CGFloat.pi }
    public var toRadians: CGFloat { return self * CGFloat.pi / 180 }
}
