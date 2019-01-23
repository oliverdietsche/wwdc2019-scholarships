import Foundation
import SpriteKit

public class CircleLayer {
    private let layerNumber: Int
    private var circlePieces: [CirclePiece]
    
    init(layerNumber: Int) {
        self.layerNumber = layerNumber
        self.circlePieces = [CirclePiece]()
    }
    
    public func rotate(angle: CGFloat) {
        for i in 0..<circlePieces.count {
            circlePieces[i].rotate(angle: angle)
        }
    }
    
    public func snap(numOfPieces: CGFloat) {
        for i in 0..<circlePieces.count {
            circlePieces[i].snap(numOfPieces: numOfPieces)
        }
    }
    
    public func addPiece(_ piece: CirclePiece) {
        self.circlePieces.append(piece)
    }
}
