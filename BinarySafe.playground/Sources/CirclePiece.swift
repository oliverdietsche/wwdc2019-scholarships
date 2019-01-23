import Foundation
import SpriteKit

public class CirclePiece {
    let borderColor: SKColor = .black
    let fillColor: SKColor = .lightGray
    let fullRadianOfCircle: CGFloat = 6.2831853
    
    private let pieceNumber: Int
    private let layerNumber: Double
    private let degreeRange: Double
    private let innerRadius: Double
    private var circleArc: SKShapeNode?
    private var label: SKLabelNode?
    
    public init(piece pieceNumber: Int, layer layerNumber: Double, degreeRange: Double, startDegree: Double, endDegree: Double, innerRadius: Double) {
        self.pieceNumber = pieceNumber
        self.layerNumber = layerNumber
        self.degreeRange = degreeRange
        self.innerRadius = innerRadius
        
        self.circleArc = self.createCircleArc(startAngle: startDegree.toRadians, endAngle: endDegree.toRadians, radius: innerRadius * (layerNumber + 1))
        self.label = createLabel(angle: startDegree.toRadians)
        guard let _ = self.label else {
            return
        }
        
        self.circleArc?.addChild(self.label!)
    }
    
    public func rotate(angle: CGFloat) {
        if angle > (self.fullRadianOfCircle / 2) || angle < (self.fullRadianOfCircle / -2) {
            var convertedAngle: CGFloat = 0
            if angle > 0 {
                convertedAngle = (self.fullRadianOfCircle - angle) * -1
            } else {
                convertedAngle = abs((self.fullRadianOfCircle * -1) - angle)
            }

            self.doRotateAction(angle: convertedAngle, duration: 0)
        } else {
            self.doRotateAction(angle: angle, duration: 0)
        }
    }
    
    public func getCircleArc() -> SKShapeNode? {
        return self.circleArc
    }
    
    public func snap(numOfPieces: CGFloat) {
        guard let circleArc = self.circleArc else {
            return
        }
        // Make zRotation always positive
        if circleArc.zRotation < 0 {
            circleArc.zRotation = self.fullRadianOfCircle + circleArc.zRotation.truncatingRemainder(dividingBy: self.fullRadianOfCircle)
        }
        
        guard let label = self.label else {
            return
        }
        let radianRangePerPiece: CGFloat = self.fullRadianOfCircle / numOfPieces
        let radianPos = abs(circleArc.zRotation).truncatingRemainder(dividingBy: self.fullRadianOfCircle)
        let radianRest = radianPos.truncatingRemainder(dividingBy: CGFloat(radianRangePerPiece))
        let snapCount = Int(radianPos / radianRangePerPiece)
        
        if radianRest < (radianRangePerPiece / 2) {
            circleArc.zRotation = radianRangePerPiece * CGFloat(snapCount)
            label.zRotation = radianRangePerPiece * CGFloat(snapCount) * -1
        } else {
            circleArc.zRotation = radianRangePerPiece * CGFloat(snapCount + 1)
            label.zRotation = radianRangePerPiece * CGFloat(snapCount + 1) * -1
        }
    }
    
    private func doRotateAction(angle: CGFloat, duration: Double) {
        guard let circleArc = self.circleArc else {
            return
        }
        let rotateAction = SKAction.rotate(byAngle: angle, duration: duration)
        circleArc.run(rotateAction)
        
        guard let label = self.label else {
            return
        }
        let antiRotateAction = SKAction.rotate(byAngle: angle * -1, duration: duration)
        label.run(antiRotateAction)
    }
    
    private func createCircleArc(startAngle: Double, endAngle: Double, radius: Double) -> SKShapeNode {
        let arc = UIBezierPath(arcCenter: CGPoint(x: 0, y: 0), radius: CGFloat(radius), startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: true)
        arc.addLine(to: CGPoint(x: 0, y: 0))
        arc.close()
        
        let circle = SKShapeNode()
        circle.fillColor = self.fillColor
        circle.lineWidth = 3.0
        circle.strokeColor = self.borderColor
        circle.path = arc.cgPath
        
        return circle
    }
    
    private func createLabel(angle: Double) -> SKLabelNode {
        let startSpace = self.innerRadius * 0.5
        let shiftedAngle = angle + Double(self.degreeRange.toRadians * 0.5)
        let radius = self.innerRadius * self.layerNumber + startSpace
        let xCord = cos(shiftedAngle) * radius
        let yCord = sin(shiftedAngle) * radius
        let posPoint = CGPoint(x: xCord, y: yCord)
        
        let label = SKLabelNode(fontNamed: "Arial")
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        label.fontSize = CGFloat(self.innerRadius * 0.8)
        label.fontColor = UIColor.black
        label.position = posPoint
        label.text = "1"
        
        return label
    }
}

