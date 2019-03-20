import SpriteKit
import AudioToolbox

public class CircleLayer {
    private let gameData: GameData
    private let layerNumber: Int
    private var circlePieces: [CirclePiece]
    
    init(gameData: GameData, layerNumber: Int, circlePieces: [CirclePiece]) {
        self.gameData = gameData
        self.layerNumber = layerNumber
        self.circlePieces = circlePieces
    }
    
    public func setFillColor(color: SKColor) {
        for i in 0..<self.circlePieces.count {
            self.circlePieces[i].setFillColor(color: color)
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
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    public func shuffle(rotationCount: Int) {
        let angle = CGFloat(rotationCount) * self.gameData.radianRange
        for i in 0..<self.circlePieces.count {
            self.circlePieces[i].shuffle(angle: angle, duration: 1)
        }
    }
    
    public func rotate(angle: CGFloat) {
//        let convertedAngle = self.convertAngleForRotation(angle)
        for i in 0..<self.circlePieces.count {
            self.circlePieces[i].rotate(angle: angle)
        }
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
    
//    Is this even necessary?
//    private func convertAngleForRotation(_ angle: CGFloat) -> CGFloat {
//        var convertedAngle: CGFloat = angle
//        if angle > CGFloat.pi || angle < (CGFloat.pi * -1) {
//            if angle > 0 {
//                convertedAngle = (GeometryData.fullRadianOfCircle - angle) * -1
//            } else {
//                convertedAngle = abs((GeometryData.fullRadianOfCircle * -1) - angle)
//            }
//        }
//        return convertedAngle
//    }
}
