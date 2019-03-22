import SpriteKit

public class CircleLayer {
    private let gameData: GameData
    private let layerNumber: Int
    private var circlePieces: [CirclePiece]
    
    init(gameData: GameData, layerNumber: Int, circlePieces: [CirclePiece]) {
        self.gameData = gameData
        self.layerNumber = layerNumber
        self.circlePieces = circlePieces
    }
    
    public func rotate(angle: CGFloat) {
        for i in 0..<self.circlePieces.count {
            self.circlePieces[i].rotate(angle: angle)
        }
    }
    
    public func setFillColor(color: SKColor) {
        for i in 0..<self.circlePieces.count {
            self.circlePieces[i].setFillColor(color: color)
        }
    }
    
    public func shuffle(rotationCount: Int) {
        let angle = CGFloat(rotationCount) * self.gameData.radianRange
        for i in 0..<self.circlePieces.count {
            self.circlePieces[i].shuffle(angle: angle, duration: 1)
        }
    }
    
    public func solve(duration: Double) {
        for i in 0..<self.circlePieces.count {
            self.circlePieces[i].solve(duration: duration)
        }
    }
    
    public func snap() {
        for i in 0..<self.circlePieces.count {
            self.circlePieces[i].snap()
        }
    }
    
    public func hasActions() -> Bool {
        var output = false
        for i in 0..<self.circlePieces.count {
            if self.circlePieces[i].hasActions() {
                output = true
            }
        }
        return output
    }
    
    public func getRotationIndex() -> Int {
        if circlePieces.count > 0 {
            return circlePieces[0].getRotationIndex()
        }
        return -1
    }
    
    public func getPiece(_ index: Int) -> CirclePiece {
        return self.circlePieces[index]
    }
}
