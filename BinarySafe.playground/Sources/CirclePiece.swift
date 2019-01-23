import Foundation
import SpriteKit

public class CirclePiece {
    let borderColor: SKColor = .black
    let fillColor: SKColor = .lightGray
    
    private let layerNumber: Int
    private let pieceNumber: Int
    private let degreeRange: Int
    private let innerRadius: Int
    private var circleArc: SKShapeNode?
    private var label: SKLabelNode?
    
    public init(layer layerNumber: Int, piece pieceNumber: Int, degreeRange: Int, startDegree: Double, endDegree: Double, innerRadius: Int) {
        self.layerNumber = layerNumber
        self.pieceNumber = pieceNumber
        self.degreeRange = degreeRange
        self.innerRadius = innerRadius
        
        self.circleArc = self.createCircleArc(startAngle: degreeToRadians(startDegree), endAngle: degreeToRadians(endDegree), radius: innerRadius * (layerNumber + 1))
        self.label = createLabel(angle: degreeToRadians(startDegree))
        guard let _ = self.label else {
            return
        }
        
        self.circleArc?.addChild(self.label!)
    }
    
    public func rotate(angle: CGFloat) {
        guard let _ = self.circleArc else {
            return
        }
        
        if angle > 3.1416 || angle < -3.1416 {
            var convertedAngle: CGFloat = 0
            if angle > 0 {
                convertedAngle = (6.2831853 - angle) * -1
            } else {
                convertedAngle = abs(-6.2831853 - angle)
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
        guard let _ = self.circleArc else {
            return
        }
        guard let _ = self.label else {
            return
        }
        
        // Make zRotation always positive
        if self.circleArc!.zRotation < 0 {
            self.circleArc!.zRotation = 6.2831853 + self.circleArc!.zRotation.truncatingRemainder(dividingBy: 6.2831853)
        }
        
        let radianRangePerPiece: CGFloat = 6.2831853 / numOfPieces
        let radianPos = abs(self.circleArc!.zRotation).truncatingRemainder(dividingBy: 6.2831853)
        let radianRest = radianPos.truncatingRemainder(dividingBy: CGFloat(radianRangePerPiece))
        let snapCount = Int(radianPos / radianRangePerPiece)
        
        if radianRest < (radianRangePerPiece / 2) {
            self.circleArc!.zRotation = radianRangePerPiece * CGFloat(snapCount)
            self.label!.zRotation = radianRangePerPiece * CGFloat(snapCount) * -1
        } else {
            self.circleArc!.zRotation = radianRangePerPiece * CGFloat(snapCount + 1)
            self.label!.zRotation = radianRangePerPiece * CGFloat(snapCount + 1) * -1
        }
    }
    
    private func doRotateAction(angle: CGFloat, duration: Double) {
        let rotateAction = SKAction.rotate(byAngle: angle, duration: duration)
        self.circleArc!.run(rotateAction)
        
        let antiRotateAction = SKAction.rotate(byAngle: angle * -1, duration: duration)
        self.label!.run(antiRotateAction)
    }
    
    private func createCircleArc(startAngle: Double, endAngle: Double, radius: Int) -> SKShapeNode {
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
        let startSpace = Double(self.innerRadius) * 0.5
        
        let xCord = cos(angle + self.degreeToRadians(Double(self.degreeRange) * 0.50)) * (Double(self.innerRadius) * Double(self.layerNumber) + startSpace)
        let yCord = sin(angle + self.degreeToRadians(Double(self.degreeRange) * 0.50)) * (Double(self.innerRadius) * Double(self.layerNumber) + startSpace)
        let point = CGPoint(x: xCord, y: yCord)
        
        let label = SKLabelNode(fontNamed: "Arial")
        label.text = "1"
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        label.fontSize = CGFloat(Double(self.innerRadius) * 0.8)
        label.fontColor = UIColor.black
        label.position = point
//        CGPoint(x: labelSpace, y: labelSpace * -1)
        
        return label
    }
    
    private func degreeToRadians(_ degree: Double) -> Double {
        return degree * Double.pi / 180.0;
    }
    
    private func radiansToDegree(_ radians: Double) -> Double {
        return radians * 180.0 / Double.pi;
    }
}

