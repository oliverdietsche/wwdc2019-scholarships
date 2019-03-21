import SpriteKit

public class CirclePiece {
    private let gameData: GameData
    private let layerNumber: Double
    private var rotationIndex: Int
    private var circleArc: SKShapeNode!
    private var label: SKLabelNode!
    
    public init(gameData: GameData, layer layerNumber: Double, startDegree: Double, endDegree: Double) {
        self.gameData = gameData
        self.layerNumber = layerNumber
        self.rotationIndex = 0
        
        let ca_startAngle = CGFloat(startDegree.toRadians)
        let ca_endAngle = CGFloat(endDegree.toRadians)
        let ca_radius = CGFloat(gameData.innerRadius * (layerNumber + 1))
        self.circleArc = self.createCircleArc(startAngle: ca_startAngle, endAngle: ca_endAngle, radius: ca_radius)
        
        let lb_angle = startDegree.toRadians
        self.label = createLabel(angle: lb_angle)
        self.circleArc.addChild(self.label)
        
        let arrow = createArrow(angle: startDegree.toRadians)
        self.circleArc.addChild(arrow)
    }
    
    public func rotate(angle: CGFloat) {
        self.abortAllActions()
        self.doRotateAction(angle: angle, duration: 0)
    }
    
    public func setFillColor(color: SKColor) {
        self.circleArc.fillColor = color
    }
    
    public func shuffle(angle: CGFloat, duration: Double) {
        self.doRotateAction(angle: angle, duration: duration)
    }
    
    public func solve(duration: Double) {
        self.abortAllActions()
        self.doRotateAction(angle: self.getConvertedZRotation(shapeNode: self.circleArc) * -1, duration: duration)
        self.rotationIndex = self.calculateRotationIndex(zRotation: self.circleArc.zRotation)
    }
    
    public func snap() {
        self.abortAllActions()
        
        let convertedZRotation = self.getConvertedZRotation(shapeNode: self.circleArc)
        self.rotationIndex = self.calculateRotationIndex(zRotation: convertedZRotation)
        
        self.circleArc.zRotation = self.gameData.radianRange * CGFloat(self.rotationIndex)
        self.label.zRotation = self.gameData.radianRange * CGFloat(self.rotationIndex) * -1
    }
    
    public func setText(_ text: String) {
        self.label.text = text
    }
    
    public func getText() -> String {
        guard let text = self.label.text else {
            return ""
        }
        return text
    }
    
    public func getRotationIndex() -> Int {
        return self.rotationIndex
    }
    
    public func getCircleArc() -> SKShapeNode? {
        return self.circleArc
    }
    
    // MARK: private
    
    // Returns zRotation of a SKShapeNode with a value between 0 and π * 2
    private func getConvertedZRotation(shapeNode: SKShapeNode) -> CGFloat {
        var convertedZRotation = shapeNode.zRotation.truncatingRemainder(dividingBy: GeometryData.fullRadianOfCircle)
        if convertedZRotation < 0 {
            convertedZRotation += GeometryData.fullRadianOfCircle
        }
        return convertedZRotation
    }
    
    // Returns the rotationIndex with a value between 0 and pieces - 1
    private func calculateRotationIndex(zRotation: CGFloat) -> Int {
        var rotationIndex = Int(zRotation / self.gameData.radianRange)
        let modZRotation = zRotation.truncatingRemainder(dividingBy: self.gameData.radianRange)
        if modZRotation > (self.gameData.radianRange / 2) {
            rotationIndex += 1
        }
        if rotationIndex == self.gameData.pieces {
            rotationIndex = 0
        }
        return rotationIndex
    }
    
    private func doRotateAction(angle: CGFloat, duration: Double) {
        let rotateAction = SKAction.rotate(byAngle: angle, duration: duration)
        self.circleArc.run(rotateAction) {
            // Wait for the rotation to end, before calculating the rotationIndex
            self.rotationIndex = self.calculateRotationIndex(zRotation: self.getConvertedZRotation(shapeNode: self.circleArc))
        }
        
        let antiRotateAction = SKAction.rotate(byAngle: angle * -1, duration: duration)
        self.label.run(antiRotateAction)
    }
    
    private func createCircleArc(startAngle: CGFloat, endAngle: CGFloat, radius: CGFloat) -> SKShapeNode {
        let arc = UIBezierPath(arcCenter: CGPoint(x: 0, y: 0), radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        arc.addLine(to: CGPoint(x: 0, y: 0))
        arc.close()
        
        let circle = SKShapeNode()
        circle.fillColor = Color.fill
        circle.strokeColor = Color.border
        circle.lineWidth = self.gameData.lineWidth
        circle.path = arc.cgPath
        circle.position = self.gameData.center
        
        return circle
    }
    
    private func createLabel(angle: Double) -> SKLabelNode {
        let shiftedAngle = angle + self.gameData.degreeRange.toRadians * 0.5
        let radius = self.gameData.innerRadius * (self.layerNumber + 0.55)
        
        let xCord = cos(shiftedAngle) * radius
        let yCord = sin(shiftedAngle) * radius
        let posPoint = CGPoint(x: xCord, y: yCord)
        
        let label = SKLabelNode(fontNamed: "Arial")
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        label.fontSize = self.gameData.circleFontSize
        label.fontColor = UIColor.black
        label.position = posPoint
        
        return label
    }
    
    private func createArrow(angle: Double) -> SKShapeNode {
        let shiftedAngle = angle + self.gameData.degreeRange.toRadians * 0.5
        let radius = self.gameData.innerRadius * (self.layerNumber + 0.55)

        let xCord = cos(shiftedAngle) * radius
        let yCord = sin(shiftedAngle) * radius
        let posPoint = CGPoint(x: xCord, y: yCord)
        
        let length = self.gameData.innerRadius * 0.15
        let marginBottom = self.gameData.innerRadius * -0.5

        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: length + marginBottom))
        path.addLine(to: CGPoint(x: length * -1, y: 0 + marginBottom))
        path.move(to: CGPoint(x: 0, y: length + marginBottom))
        path.addLine(to: CGPoint(x: length, y: 0 + marginBottom))
        path.addLine(to: CGPoint(x: length * -1, y: 0 + marginBottom))

        let arrow = SKShapeNode(path: path.cgPath)
        arrow.fillColor = Color.arrow
        arrow.lineWidth = 0
        arrow.zPosition = 1
        arrow.position = posPoint
        // zRotation gets corrected, because the unit circle starts with 90 degree on the top
        arrow.zRotation = CGFloat(shiftedAngle) - (GeometryData.fullRadianOfCircle * 0.25)

        return arrow
    }
    
    private func abortAllActions() {
        self.circleArc.removeAllActions()
        self.label.removeAllActions()
    }
    
    //    private func createArrowLine(angle: Double) -> SKShapeNode {
    //        let radius = self.gameData.innerRadius * (self.layerNumber + 0.55)
    //
    //        let length = self.gameData.innerRadius * 0.5
    //        let marginTop = length * 0.5
    //
    //        let xCord = cos(angle) * radius
    //        let yCord = sin(angle) * radius
    //        let posPoint = CGPoint(x: xCord, y: yCord)
    //
    //        let path = UIBezierPath()
    //        path.move(to: CGPoint(x: 0, y: length - marginTop))
    //        path.addLine(to: CGPoint(x: length * -0.5, y: 0 - marginTop))
    //        path.move(to: CGPoint(x: 0, y: length - marginTop))
    //        path.addLine(to: CGPoint(x: length * 0.5, y: 0 - marginTop))
    //
    //        let line = SKShapeNode(path: path.cgPath)
    //        line.zPosition = 1
    //        line.strokeColor = self.gameData.borderColor
    //        line.lineWidth = self.gameData.lineWidth * 0.75
    //        line.position = posPoint
    //        line.zRotation = CGFloat(angle) - (GeometryData.fullRadianOfCircle * 0.25)
    //
    //        return line
    //    }
}

