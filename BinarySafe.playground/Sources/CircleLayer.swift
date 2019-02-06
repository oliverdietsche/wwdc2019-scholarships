import Foundation
import SpriteKit

public class CircleLayer {
    private let layerNumber: Int
    private var circlePieces: [CirclePiece]
    private let numOfPieces: Int
    private let degreeRange: Double
    
    init(layerNumber: Int, circlePieces: [CirclePiece], numOfPieces: Int, degreeRange: Double) {
        self.layerNumber = layerNumber
        self.circlePieces = circlePieces
        self.numOfPieces = numOfPieces
        self.degreeRange = degreeRange
    }
    
    public func getRotatedIndex() -> Double {
        if circlePieces.count > 0 {
            return circlePieces[0].getRotatedIndex()
        }
        return -1
    }
    
    public func getDegPos() -> CGFloat {
        guard let rootCirclePiece = self.circlePieces[0].getCircleArc() else {
            return -1
        }
        return rootCirclePiece.zRotation
    }
    
    public func getPiece(_ index: Int) -> CirclePiece {
        return self.circlePieces[index]
    }
    
    public func shuffle() {
        let turn = Int.random(in: 0..<self.numOfPieces)
        let angle = CGFloat(Double(turn) * self.degreeRange.toRadians)
        for i in 0..<self.circlePieces.count {
            self.circlePieces[i].shuffle(angle: angle)
        }
    }
    
    public func rotate(angle: CGFloat) {
        for i in 0..<self.circlePieces.count {
            self.circlePieces[i].rotate(angle: angle)
        }
    }
    
    public func snap(numOfPieces: CGFloat) {
        for i in 0..<self.circlePieces.count {
            self.circlePieces[i].snap(numOfPieces: numOfPieces)
        }
    }
}
