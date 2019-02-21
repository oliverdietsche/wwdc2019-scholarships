import PlaygroundSupport
import SpriteKit
import Foundation

public class GameScene: SKScene {
    let lineWidth: CGFloat = 3
    
    private let gameData: GameData
    private var innerCircle: SKShapeNode
    private var helpLabel: SKLabelNode
    private var movesLabel: SKLabelNode
    private var moves: Int
    private var solved: Bool
    
    private var helpColumn: Int?
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
        self.helpLabel = SKLabelNode(fontNamed: "Arial")
        self.movesLabel = SKLabelNode(fontNamed: "Arial")
        self.moves = 0
        self.solved = false
        
        super.init(size: CGSize(width: gameData.width, height: gameData.height))
    }
    
    public override func didMove(to view: SKView) {
        self.setup()
        
        guard let safe = self.safe else {
            return
        }
        
        let maxPossibleValue = Int(pow(2, Double(self.gameData.layers)))
        
        var code = [Int]()
        var startDegree: Double = 0
        for iPiece in 0..<self.gameData.pieces {
            let codeNumber: Int = Int.random(in: 0..<maxPossibleValue)
            let codeArray = self.intToBinaryCharArray(int: codeNumber, amountOfChars: self.gameData.layers)
            code.append(codeNumber)
            
            let shiftedAngle = startDegree.toRadians + Double(self.gameData.radianRange) * 0.5
            let radius = self.gameData.innerRadius * (Double(self.gameData.layers) + 1.5)
            let xCord = cos(shiftedAngle) * radius
            let yCord = sin(shiftedAngle) * radius
            let position = CGPoint(x: CGFloat(xCord) + self.gameData.center.x, y: CGFloat(yCord) + self.gameData.center.y)
            
            let size = sqrt(self.gameData.innerRadius * self.gameData.innerRadius * 0.5)
            let helpButton = HelpButton(size: CGSize(width: size, height: size), text: String(codeNumber), column: iPiece, degree: shiftedAngle.toDegrees)
            helpButton.delegate = self
            helpButton.position = position
            self.addChild(helpButton)
            
            var codeIndex = 0
            for iLayer in (0..<self.gameData.layers).reversed() {
                safe.getLayer(iLayer).getPiece(iPiece).setText(String(codeArray[codeIndex]))
                codeIndex += 1
            }
            startDegree += self.gameData.degreeRange
        }
        safe.setCode(code)
    }
    
    private func intToBinaryCharArray(int: Int, amountOfChars: Int) -> [Character] {
        var result = String(int, radix: 2)
        while result.count < amountOfChars {
            result = "0" + result
        }
        return Array(result)
    }
    
    func touchDown(atPoint pos : CGPoint) {
        if solved {
            return
        }
        self.updateActiveLayer(touchedPos: pos)
        
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
        guard let safe = self.safe else {
            return
        }
        guard let activeLayer = self.activeLayer else {
            return
        }
        activeLayer.snap()
        
        self.moves += 1
        self.movesLabel.text = "Moves:\(self.moves)"
        self.updateHelp()
        
        if safe.isSolved() {
            self.solved = true
            self.spawnParticles(position: self.gameData.center)
        }
    }
    
    // MARK: private
    
    private func setup() {
        self.backgroundColor = .white
        
        let movesLabel_position = CGPoint(x: 10, y: self.gameData.height - 30)
        self.setupLabel(label: self.movesLabel, position: movesLabel_position, fontSize: 20, text: "Moves:\(self.moves)", hAlignment: .left)
        
        let helpLabel_position = CGPoint(x: Double(self.gameData.center.x), y: self.gameData.height - 100)
        self.setupLabel(label: self.helpLabel, position: helpLabel_position, fontSize: 30, text: "HelpLabel", hAlignment: .center)
        
        self.setupInnerCircle()
        
        self.setupButtons()
        
        self.setupSafe()
    }
    
    private func setupLabel(label: SKLabelNode, position: CGPoint, fontSize: CGFloat, text: String, hAlignment: SKLabelHorizontalAlignmentMode) {
        label.position = position
        label.zPosition = 1
        label.fontSize = fontSize
        label.fontColor = .black
        label.text = text
        label.horizontalAlignmentMode = hAlignment
        label.verticalAlignmentMode = .center
        self.addChild(label)
    }
    
    private func setupInnerCircle() {
        self.innerCircle.position = self.gameData.center
        self.innerCircle.zPosition = 1
        self.innerCircle.lineWidth = self.lineWidth
        self.innerCircle.strokeColor = self.gameData.borderColor
        self.innerCircle.fillColor = self.gameData.centerColor
        self.addChild(self.innerCircle)
    }
    
    private func setupButtons() {
        let shuffleButton = GameControlButton(size: CGSize(width: 60, height: 60), type: .shuffle, texture: SKTexture(imageNamed: "shuffle2.png"))
        shuffleButton.delegate = self
        shuffleButton.position = CGPoint(x: 40, y: 40)
        self.addChild(shuffleButton)
        
        let homeButton = GameControlButton(size: CGSize(width: 60, height: 60), type: .home, texture: SKTexture(imageNamed: "home.png"))
        homeButton.delegate = self
        homeButton.position = CGPoint(x: self.gameData.center.x, y: 40)
        self.addChild(homeButton)
        
        let solveButton = GameControlButton(size: CGSize(width: 60, height: 60), type: .solve, texture: SKTexture(imageNamed: "solve.png"))
        solveButton.delegate = self
        solveButton.position = CGPoint(x: self.gameData.width - 40, y: 40)
        self.addChild(solveButton)
    }
    
    private func setupSafe() {
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
        safe.shuffle()
        
        self.safe = safe
    }
    
    private func updateActiveLayer(touchedPos pos: CGPoint) {
        let radius = Double(distanceBetweenCGPoints(from: self.gameData.center, to: pos))
        let calculatedLayer = Int(radius / self.gameData.innerRadius) - self.gameData.layers
        
        guard let safe = self.safe else {
            return
        }
        self.activeLayer = safe.getLayer(self.convertCalculatedLayer(calculatedLayer))
    }
    
    private func spawnParticles(position: CGPoint) {
        guard let particles = SKEmitterNode(fileNamed: "MyParticle") else {
            return
        }
        particles.position = position
        particles.targetNode = self.scene
        self.addChild(particles)
    }
    
    private func updateHelp() {
        guard let safe = self.safe else {
            return
        }
        safe.resetFillColor()
        self.helpLabel.text = "HelpLabel"
        guard let column = self.helpColumn else {
            return
        }
        self.helpLabel.text = safe.getCodeWithKeyFromColumn(column)
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
}

extension GameScene: SKButtonDelegate, HelpButtonDelegate {
    public func displayHelp(column: Int) {
        if self.helpColumn == column {
            self.helpColumn = nil
        } else {
            self.helpColumn = column
        }
        self.updateHelp()
    }
    
    public func loadGameScene() {
        fatalError("Not supported in GameScene")
    }
    
    public func shuffleLayers() {
        guard let safe = self.safe else {
            return
        }
        
        self.moves = 0
        self.movesLabel.text = "Moves: \(self.moves)"
        
        // Make sure the shuffle don't solve it
        safe.solve(duration: 0)
        
        self.innerCircle.fillColor = self.gameData.centerColor
        safe.shuffle()
        self.solved = false
    }
    
    public func loadHomeScene() {
        guard let view = self.view else {
            return
        }
        view.subviews.forEach({ $0.removeFromSuperview() })
        view.presentScene(MenuScene(self.gameData), transition: SKTransition.crossFade(withDuration: 1))
    }
    
    public func solveLayers() {
        if solved {
            return
        }
        guard let safe = self.safe else {
            return
        }
        self.solved = true
        self.movesLabel.text = "Auto-Solved"
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
