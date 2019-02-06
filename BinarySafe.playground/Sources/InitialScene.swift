import PlaygroundSupport
import SpriteKit
import Foundation

public class InitialScene: SKScene {
    let borderColor: SKColor = .black
    let centerColor: SKColor = .gray
    let lineWidth: CGFloat = 3
    
    private let innerRadius: Double
    private let numOfLayers: Int
    private let numOfPieces: Int
    private let center: CGPoint
    private var innerCircle: SKShapeNode
    
    private var safe: Safe?
    
    private var activeLayer = CircleLayer(layerNumber: 0, circlePieces: [], numOfPieces: 0, degreeRange: 0)
    private var pDown = CGPoint()
    private var p1 = CGPoint()
    private var p2 = CGPoint()
    
    required init?(coder aDecoder: NSCoder) {
        self.innerRadius = 0
        self.numOfLayers = 0
        self.numOfPieces = 0
        self.center = CGPoint()
        self.innerCircle = SKShapeNode()
        
        super.init(coder: aDecoder)
    }
    
    public init(size: CGSize, layers numOfLayers: Int, pieces numOfPieces: Int) {
        var innerRadius: Double = 0
        
        if size.width > size.height {
            innerRadius = Double(size.height / 2) / Double(numOfLayers + 3)
        } else {
            innerRadius = Double(size.width / 2) / Double(numOfLayers + 3)
        }
        
        self.innerRadius = innerRadius
        self.numOfLayers = numOfLayers
        self.numOfPieces = numOfPieces
        self.center = CGPoint(x: size.width / 2, y: size.height / 2)
        self.innerCircle = SKShapeNode(circleOfRadius: CGFloat(innerRadius))

        super.init(size: size)
    }
    
    public override func didMove(to view: SKView) {
        self.innerCircle.lineWidth = self.lineWidth
        self.innerCircle.position = self.center
        self.innerCircle.strokeColor = self.borderColor
        self.innerCircle.fillColor = self.centerColor
        
        let degreeRange: Double = 360 / Double(self.numOfPieces)
        
        var layers = [CircleLayer]()
        for iLayer in (1...self.numOfLayers).reversed() {
            var startDegree: Double = 0
            var circlePieces = [CirclePiece]()
            
            for _ in 1...self.numOfPieces {
                let endDegree: Double = startDegree + degreeRange
                
                let piece = CirclePiece(layer: Double(iLayer), degreeRange: degreeRange, startDegree: startDegree, endDegree: endDegree, innerRadius: self.innerRadius, numOfPieces: self.numOfPieces)
                circlePieces.append(piece)
                
                guard let circleArc = piece.getCircleArc() else {
                    return
                }
                circleArc.position = self.center
                self.addChild(circleArc)
                
                startDegree += degreeRange
            }
            
            layers.append(CircleLayer(layerNumber: iLayer, circlePieces: circlePieces, numOfPieces: self.numOfPieces, degreeRange: degreeRange))
        }
        
        self.safe = Safe(layers: layers, numOfPieces: numOfPieces, numOfLayers: numOfLayers, innerRadius: innerRadius, degreeRange: degreeRange, center: self.center)
        if let safe = self.safe {
            let codeLabels = safe.getCodeLabels()
            for i in 0..<codeLabels.count {
                self.addChild(codeLabels[i])
            }
//            safe.shuffle()
        }
        
        self.backgroundColor = .white
        self.addChild(innerCircle)
    }
    
    func touchDown(atPoint pos : CGPoint) {
        let radius = Double(distanceBetweenCGPoints(from: self.center, to: pos))
        let calculatedLayer = Int(radius / self.innerRadius) - self.numOfLayers
        
        guard let safe = self.safe else {
            return
        }
        if calculatedLayer > 0 {
            self.activeLayer = safe.getLayer(0)
        } else if abs(calculatedLayer) >= self.numOfLayers {
            self.activeLayer = safe.getLayer(self.numOfLayers - 1)
        } else {
            self.activeLayer = safe.getLayer(abs(calculatedLayer))
        }
        
        self.pDown = pos
        self.p1 = pos
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        self.p2 = pos
        
        let v1 = CGVector(dx: self.p1.x - self.center.x, dy: self.p1.y - self.center.y)
        let v2 = CGVector(dx: self.p2.x - self.center.x, dy: self.p2.y - self.center.y)
        let angle = atan2(v2.dy, v2.dx) - atan2(v1.dy, v1.dx)
        
        self.activeLayer.rotate(angle: angle)
        
        self.p1 = pos
    }
    
    func touchUp(atPoint pos : CGPoint) {
        self.activeLayer.snap(numOfPieces: CGFloat(self.numOfPieces))
        
        if let safe = self.safe {
            safe.getDegPos()
        }
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchDown(atPoint: t.location(in: self)) }
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchMoved(toPoint: t.location(in: self)) }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchUp(atPoint: t.location(in: self)) }
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchUp(atPoint: t.location(in: self)) }
    }
    
    public override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    private func distanceBetweenCGPoints(from: CGPoint, to: CGPoint) -> CGFloat {
        return sqrt(distanceBetweenCGPointsSquared(from: from, to: to))
    }
    
    private func distanceBetweenCGPointsSquared(from: CGPoint, to: CGPoint) -> CGFloat {
        return (from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y)
    }
}
