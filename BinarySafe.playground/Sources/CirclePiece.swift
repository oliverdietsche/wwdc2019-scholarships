import Foundation
import SpriteKit

public class CirclePiece {
    let borderColor: SKColor = .black
    let fillColor: SKColor = .lightGray
    let fullRadianOfCircle: CGFloat = 6.2831853
    
    private let layerNumber: Double
    private let degreeRange: Double
    private let startDegree: Double
    private let endDegree: Double
    private let innerRadius: Double
    private let numOfPieces: Int
    private var rotatedIndex: Double
    private var circleArc: SKShapeNode?
    private var label: SKLabelNode?
    
    public init(layer layerNumber: Double, degreeRange: Double, startDegree: Double, endDegree: Double, innerRadius: Double, numOfPieces: Int) {
        self.layerNumber = layerNumber
        self.degreeRange = degreeRange
        self.startDegree = startDegree
        self.endDegree = endDegree
        self.innerRadius = innerRadius
        self.numOfPieces = numOfPieces
        self.rotatedIndex = 0
        
        let ca_startAngle = CGFloat(startDegree.toRadians)
        let ca_endAngle = CGFloat(endDegree.toRadians)
        let ca_radius = CGFloat(innerRadius * (layerNumber + 1))
        
        self.circleArc = self.createCircleArc(startAngle: ca_startAngle, endAngle: ca_endAngle, radius: ca_radius)
        
        let lb_angle = startDegree.toRadians
        
        self.label = createLabel(angle: lb_angle)
        
        guard let circleArc = self.circleArc else {
            return
        }
        guard let label = self.label else {
            return
        }
        circleArc.addChild(label)
    }
    
    public func getRotatedIndex() -> Double {
        return self.rotatedIndex
    }
    
    public func shuffle(angle: CGFloat) {
        self.doRotateAction(angle: angle, duration: 0)
    }
    
    public func setText(_ text: String) {
        guard let label = self.label else {
            return
        }
        label.text = text
    }
    
    public func getText() -> String {
        guard let label = self.label else {
            return ""
        }
        guard let text = label.text else {
            return ""
        }
        return text
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
        
        let radianRangePerPiece: CGFloat = self.fullRadianOfCircle / numOfPieces
        let radianPos = abs(circleArc.zRotation).truncatingRemainder(dividingBy: self.fullRadianOfCircle)
        let radianRest = radianPos.truncatingRemainder(dividingBy: CGFloat(radianRangePerPiece))
        let snapCount = Int(radianPos / radianRangePerPiece)
        
        guard let label = self.label else {
            return
        }
        
        if radianRest < (radianRangePerPiece / 2) {
            circleArc.zRotation = radianRangePerPiece * CGFloat(snapCount)
            label.zRotation = radianRangePerPiece * CGFloat(snapCount) * -1
        } else {
            circleArc.zRotation = radianRangePerPiece * CGFloat(snapCount + 1)
            label.zRotation = radianRangePerPiece * CGFloat(snapCount + 1) * -1
        }
        
        self.rotatedIndex = round(Double(circleArc.zRotation) / Double(radianRangePerPiece))
        if self.rotatedIndex == Double(self.numOfPieces) {
            self.rotatedIndex = 0
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
    
    private func createCircleArc(startAngle: CGFloat, endAngle: CGFloat, radius: CGFloat) -> SKShapeNode {
        let arc = UIBezierPath(arcCenter: CGPoint(x: 0, y: 0), radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        arc.addLine(to: CGPoint(x: 0, y: 0))
        arc.close()
        
        let circle = SKShapeNode()
        circle.fillColor = self.fillColor
        circle.strokeColor = self.borderColor
        circle.lineWidth = 3.0
        circle.path = arc.cgPath
        
        return circle
    }
    
    private func createLabel(angle: Double) -> SKLabelNode {
        let shiftedAngle = angle + self.degreeRange.toRadians * 0.5
        let radius = self.innerRadius * (self.layerNumber + 0.5)
        
        let xCord = cos(shiftedAngle) * radius
        let yCord = sin(shiftedAngle) * radius
        let posPoint = CGPoint(x: xCord, y: yCord)
        
        let label = SKLabelNode(fontNamed: "Arial")
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        label.fontSize = CGFloat(self.innerRadius * 0.8)
        label.fontColor = UIColor.black
        label.position = posPoint
//        label.text = "1"
        
        return label
    }
}

