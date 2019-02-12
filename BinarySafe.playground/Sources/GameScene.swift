import PlaygroundSupport
import SpriteKit
import Foundation

public class GameScene: SKScene {
    let lineWidth: CGFloat = 3
    
    private let gameData: GameData
    private var innerCircle: SKShapeNode
    private var helpDescription_label: SKLabelNode
    private var help_label: SKLabelNode
    private var moves_label: SKLabelNode
    private var moves: Int
    private var solved: Bool
    
    private var safe: Safe?
    private var activeLayer: CircleLayer?
    
    private var p1 = CGPoint()
    private var p2 = CGPoint()
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    public init(_ gameData: GameData) {
        self.gameData = gameData
        self.innerCircle = SKShapeNode(circleOfRadius: CGFloat(gameData.innerRadius))
        self.helpDescription_label = SKLabelNode(fontNamed: "Arial")
        self.help_label = SKLabelNode(fontNamed: "Arial")
        self.moves_label = SKLabelNode(fontNamed: "Arial")
        self.moves = 0
        self.solved = false
        
        super.init(size: CGSize(width: gameData.width, height: gameData.height))
    }
    
    public override func didMove(to view: SKView) {
        let home_uibutton = self.newUIButton(text: "🏠", x: Double(self.gameData.center.x) - 40, y: self.gameData.height - 90)
        home_uibutton.addTarget(self, action: #selector(self.loadHomeScene), for: .touchUpInside)
        let refresh_uibutton = self.newUIButton(text: "↺", x: 10, y: self.gameData.height - 90)
        refresh_uibutton.addTarget(self, action: #selector(self.shuffleLayers), for: .touchUpInside)
        let solve_uibutton = self.newUIButton(text: "✔️", x: self.gameData.width - 90, y: self.gameData.height - 90)
        solve_uibutton.addTarget(self, action: #selector(self.solve), for: .touchUpInside)
        
        view.addSubview(home_uibutton)
        view.addSubview(refresh_uibutton)
        view.addSubview(solve_uibutton)
        
//        let home_texture = SKTexture(imageNamed: "home")
//        let home_selectedTexture = SKTexture(imageNamed: "home_selected")
//        let home_button = Button(normalTexture: home_texture, selectedTexture: home_selectedTexture, disabledTexture: nil)
//        home_button.size = CGSize(width: 50, height: 50)
//        home_button.position = CGPoint(x: Double(self.gameData.center.x), y: 35)
//        home_button.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(self.loadHomeScene))
//        self.addChild(home_button)
//
//        let solve_normalTexture = SKTexture(imageNamed: "solve")
//        let solve_selectedTexture = SKTexture(imageNamed: "solve_selected")
//        let solve_button = Button(normalTexture: solve_normalTexture, selectedTexture: solve_selectedTexture, disabledTexture: nil)
//        solve_button.size = CGSize(width: 50, height: 50)
//        solve_button.position = CGPoint(x: self.gameData.width - 60, y: 35)
//        solve_button.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(self.solve))
//        self.addChild(solve_button)
        
//        self.helpDescription_label.position = CGPoint(x: 10, y: self.gameData.height - 70)
//        self.helpDescription_label.zPosition = 50
//        self.helpDescription_label.fontSize = 20
//        self.helpDescription_label.fontColor = .black
//        var helpNum = pow(2, Double(self.gameData.layers - 1))
//        var helpDescription = ""
//        print(helpNum)
//        for _ in 0..<self.gameData.layers {
//            helpDescription += " \(Int(helpNum))"
//            helpNum *= 0.5
//        }
//        self.helpDescription_label.text = helpDescription
//        self.helpDescription_label.horizontalAlignmentMode = .left
//        self.helpDescription_label.verticalAlignmentMode = .bottom
//        self.addChild(self.helpDescription_label)
        
        self.help_label.position = CGPoint(x: 10, y: self.gameData.height - 100)
        self.help_label.zPosition = 50
        self.help_label.fontSize = 30
        self.help_label.fontColor = .black
        self.help_label.text = "101 = 5"
        self.help_label.horizontalAlignmentMode = .left
        self.help_label.verticalAlignmentMode = .bottom
        self.addChild(self.help_label)
        
        self.moves_label.position = CGPoint(x: 10, y: self.gameData.height - 30)
        self.moves_label.zPosition = 50
        self.moves_label.fontSize = 20
        self.moves_label.fontColor = .black
        self.moves_label.text = "Moves:\(self.moves)"
        self.moves_label.horizontalAlignmentMode = .left
        self.moves_label.verticalAlignmentMode = .bottom
        self.addChild(self.moves_label)
        
        self.innerCircle.position = self.gameData.center
        self.innerCircle.zPosition = 50
        self.innerCircle.lineWidth = self.lineWidth
        self.innerCircle.strokeColor = self.gameData.borderColor
        self.innerCircle.fillColor = self.gameData.centerColor
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
        if solved {
            return
        }
        let radius = Double(distanceBetweenCGPoints(from: self.gameData.center, to: pos))
        let calculatedLayer = Int(radius / self.gameData.innerRadius) - self.gameData.layers
        
        guard let safe = self.safe else {
            return
        }
        self.activeLayer = safe.getLayer(self.convertCalculatedLayer(calculatedLayer))
        print(safe.getCodeWithKeyFromColumn(0))
        
        self.p1 = pos
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if solved {
            return
        }
        self.p2 = pos
        
        guard let activeLayer = self.activeLayer else {
            return
        }
        activeLayer.rotate(angle: self.calculateAngle(point1: self.p1, point2: self.p2))
        
        self.p1 = pos
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if solved {
            return
        }
        guard let activeLayer = self.activeLayer else {
            return
        }
        activeLayer.snap()
        self.moves += 1
        self.moves_label.text = "Moves:\(self.moves)"
        
        guard let safe = self.safe, safe.isSolved() else {
            return
        }
        self.solved = true
        
        guard let particles = SKEmitterNode(fileNamed: "MyParticle") else {
            return
        }
        particles.position = self.gameData.center
        particles.targetNode = self.scene
        self.addChild(particles)
    }
    
    // MARK: private
    
    private func newUIButton(text: String, x: Double, y: Double) -> UIButton {
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
    
    @objc func loadHomeScene() {
        guard let view = self.view else {
            return
        }
        view.subviews.forEach({ $0.removeFromSuperview() })
        view.presentScene(self.gameData.newMenuScene(), transition: SKTransition.crossFade(withDuration: 1))
    }
    
    @objc func shuffleLayers() {
        guard let safe = self.safe else {
            return
        }
        
        self.moves = 0
        self.moves_label.text = "Moves: \(self.moves)"
        
        // Make sure the shuffle don't solve it
        safe.solve(duration: 0)
        
        self.innerCircle.fillColor = self.gameData.centerColor
        safe.shuffle()
        self.solved = false
    }
    
    @objc func solve() {
        if solved {
            return
        }
        guard let safe = self.safe else {
            return
        }
        self.solved = true
        safe.solve(duration: 1.5)
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
