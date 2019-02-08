import PlaygroundSupport
import SpriteKit
import Foundation

public class GameScene: SKScene {
    let borderColor: SKColor = .black
    let centerColor: SKColor = .gray
    let lineWidth: CGFloat = 3
    
    private let gameData: GameData
    private var innerCircle: SKShapeNode
    private var moves: Int
    
    private var safe: Safe?
    private var activeLayer: CircleLayer?
    
    private var p1 = CGPoint()
    private var p2 = CGPoint()
    
    required init?(coder aDecoder: NSCoder) {
        self.gameData = GameData(layers: 0, pieces: 0, borderColor: .red, fillColor: .red, centerColor: .red)
        self.innerCircle = SKShapeNode()
        self.moves = 0
        
        super.init(coder: aDecoder)
    }
    
    public init(_ gameData: GameData) {
        self.gameData = gameData
        self.innerCircle = SKShapeNode(circleOfRadius: CGFloat(gameData.innerRadius))
        self.moves = 0
        
        super.init(size: CGSize(width: gameData.width, height: gameData.height))
    }
    
    public override func didMove(to view: SKView) {
        let home_button = self.newButton(text: "🏠", x: self.gameData.width / 2 - 125, y: 10)
        home_button.addTarget(self, action: #selector(loadHomeScene(_:)), for: .touchUpInside)
        let refresh_button = self.newButton(text: "↺", x: self.gameData.width / 2 - 35, y: 10)
        refresh_button.addTarget(self, action: #selector(shuffleLayers(_:)), for: .touchUpInside)
        let solve_button = self.newButton(text: "✔️", x: self.gameData.width / 2 + 55, y: 10)
        solve_button.addTarget(self, action: #selector(solve(_:)), for: .touchUpInside)
        guard let view = self.view else {
            return
        }
        view.addSubview(home_button)
        view.addSubview(refresh_button)
        view.addSubview(solve_button)
        
        self.innerCircle.lineWidth = self.lineWidth
        self.innerCircle.position = self.gameData.center
        self.innerCircle.strokeColor = self.borderColor
        self.innerCircle.fillColor = self.centerColor
        self.innerCircle.zPosition = 50
        self.addChild(self.innerCircle)
        self.backgroundColor = .white
        
        var layers = [CircleLayer]()
        for iLayer in (1...self.gameData.layers).reversed() {
            var startDegree: Double = 0
            var circlePieces = [CirclePiece]()
            
            for _ in 1...self.gameData.pieces {
                let endDegree: Double = startDegree + self.gameData.degreeRange
                
                let piece = CirclePiece(gameData: self.gameData, layer: Double(iLayer), startDegree: startDegree, endDegree: endDegree)
                circlePieces.append(piece)
                
                guard let circleArc = piece.getCircleArc() else {
                    return
                }
                self.addChild(circleArc)
                
                startDegree += self.gameData.degreeRange
            }
            
            let layer = CircleLayer(gameData: self.gameData, layerNumber: iLayer, circlePieces: circlePieces)
            layers.append(layer)
        }
        
        let safe = Safe(gameData: self.gameData, layers: layers)
        
        let codeLabels = safe.getCodeLabels()
        for i in 0..<codeLabels.count {
            self.addChild(codeLabels[i])
        }
        safe.shuffle()
        
        self.safe = safe
    }
    
    func touchDown(atPoint pos : CGPoint) {
        let radius = Double(distanceBetweenCGPoints(from: self.gameData.center, to: pos))
        let calculatedLayer = Int(radius / self.gameData.innerRadius) - self.gameData.layers
        
        guard let safe = self.safe else {
            return
        }
        self.activeLayer = safe.getLayer(self.convertCalculatedLayer(calculatedLayer))
        
        self.p1 = pos
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        self.p2 = pos
        
        guard let activeLayer = self.activeLayer else {
            return
        }
        activeLayer.rotate(angle: self.calculateAngle(point1: self.p1, point2: self.p2))
        
        self.p1 = pos
    }
    
    func touchUp(atPoint pos : CGPoint) {
        guard let activeLayer = self.activeLayer else {
            return
        }
        activeLayer.snap()
        self.moves += 1
        
        guard let safe = self.safe, safe.isSolved() else {
            return
        }
        
        self.isUserInteractionEnabled = false
        self.innerCircle.fillColor = .green
    }
    
    // MARK: private
    
    private func newButton(text: String, x: Double, y: Double) -> UIButton {
        let home_button = UIButton(frame: CGRect(x: x, y: y, width: 80, height: 80))
        home_button.setTitle(text, for: .normal)
        home_button.titleLabel?.font = .systemFont(ofSize: 70)
        home_button.setTitleColor(UIColor.black, for: .normal)
        return home_button
    }
    
    private func calculateAngle(point1 p1: CGPoint, point2 p2: CGPoint) -> CGFloat {
        let v1 = CGVector(dx: p1.x - self.gameData.center.x, dy: p1.y - self.gameData.center.y)
        let v2 = CGVector(dx: p2.x - self.gameData.center.x, dy: p2.y - self.gameData.center.y)
        return atan2(v2.dy, v2.dx) - atan2(v1.dy, v1.dx)
    }
    
    private func convertCalculatedLayer(_ calculatedLayer: Int) -> Int {
        if calculatedLayer > 0 {
            return 0
        } else if abs(calculatedLayer) >= self.gameData.layers {
            return self.gameData.layers - 1
        } else {
            return abs(calculatedLayer)
        }
    }
    
    private func distanceBetweenCGPoints(from: CGPoint, to: CGPoint) -> CGFloat {
        return sqrt(distanceBetweenCGPointsSquared(from: from, to: to))
    }
    
    private func distanceBetweenCGPointsSquared(from: CGPoint, to: CGPoint) -> CGFloat {
        return (from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y)
    }
    
    @objc func loadHomeScene(_ sender: UIButton) {
        guard let view = self.view else {
            return
        }
        view.subviews.forEach({ $0.removeFromSuperview() })
        view.presentScene(self.gameData.newMenuScene(), transition: SKTransition.crossFade(withDuration: 1))
    }
    
    @objc func shuffleLayers(_ sender: UIButton) {
        guard let safe = self.safe else {
            return
        }
        // Make sure the shuffle don't solve it
        safe.solve(duration: 0)
        
        self.innerCircle.fillColor = self.centerColor
        safe.shuffle()
        self.isUserInteractionEnabled = true
    }
    
    @objc func solve(_ sender: UIButton) {
        guard let safe = self.safe else {
            return
        }
        self.isUserInteractionEnabled = false
        safe.solve(duration: 1.5)
        self.innerCircle.fillColor = .green
    }
}

extension GameScene {
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
}
